# rubocop:disable RSpec/MultipleMemoizedHelpers
# Justification: All memoized helpers (dummy_class, field_name, field_value, cached_object, cached_at, ttl, cache_key)
# are used across multiple tests to ensure DRY setup for cache key generation and cache behavior testing.
require 'rails_helper'

RSpec.describe CacheService do
  let(:dummy_class) { Class.new { def self.name; 'Dummy'; end } }
  let(:field_name) { :id }
  let(:field_value) { 123 }
  let(:cached_object) { Object.new } # Use a plain Object since cached_object is generic
  let(:cached_at) { Time.current }
  let(:ttl) { 1.hour }
  let(:cache_key) { "dummy/#{field_name}/#{field_value}" }

  describe '.fetch' do
    it 'instantiates a new CacheService and delegates to instance fetch method' do
      service_instance = instance_double(described_class)
      allow(described_class).to receive(:new).and_return(service_instance)
      allow(service_instance).to receive(:fetch).with(dummy_class, field_name, field_value, ttl: ttl).and_return([ cached_object, cached_at, true ])
      result = described_class.fetch(dummy_class, field_name, field_value, ttl: ttl) { cached_object }
      expect(result).to eq([ cached_object, cached_at, true ])
      expect(described_class).to have_received(:new)
      expect(service_instance).to have_received(:fetch)
    end
  end

  describe '#fetch' do
    subject(:service) { described_class.new }

    context 'when the object is already cached' do
      before do
        allow(Rails.cache).to receive(:read).with(cache_key).and_return({ object: cached_object, cached_at: cached_at })
      end

      it 'returns the cached object, timestamp, and cache hit status' do
        result = service.fetch(dummy_class, field_name, field_value, ttl: ttl) { raise 'Block should not be called' }
        expect(result).to eq([ cached_object, cached_at, true ])
      end

      it 'does not call the block' do
        expect { |b| service.fetch(dummy_class, field_name, field_value, ttl: ttl, &b) }.not_to yield_control
      end
    end

    context 'when the object is not cached' do
      before do
        allow(Rails.cache).to receive(:read).with(cache_key).and_return(nil)
        allow(Time).to receive(:current).and_return(cached_at)
        allow(Rails.cache).to receive(:write).with(cache_key, { object: cached_object, cached_at: cached_at }, expires_in: ttl)
      end

      it 'calls the block, caches the result, and returns the object, timestamp, and cache miss status' do
        result = service.fetch(dummy_class, field_name, field_value, ttl: ttl) { cached_object }
        expect(result).to eq([ cached_object, cached_at, false ])
        expect(Rails.cache).to have_received(:write).with(cache_key, { object: cached_object, cached_at: cached_at }, expires_in: ttl)
      end

      it 'uses the default TTL if none is provided' do
        allow(Rails.cache).to receive(:write).with(cache_key, anything, expires_in: described_class::DEFAULT_TTL)
        service.fetch(dummy_class, field_name, field_value) { cached_object }
        expect(Rails.cache).to have_received(:write).with(cache_key, anything, expires_in: described_class::DEFAULT_TTL)
      end
    end
  end

  describe '#generate_cache_key' do
    subject(:service) { described_class.new }

    it 'generates a cache key based on class name, field name, and field value' do
      expect(service.send(:generate_cache_key, dummy_class, field_name, field_value)).to eq(cache_key)
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
