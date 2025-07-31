require 'rails_helper'

RSpec.describe Geocoding::ReverseService, type: :service do
  let(:latitude) { 37.4221 }
  let(:longitude) { -122.0841 }
  let(:valid_result) do
    {
      address: "1600 Amphitheatre Parkway, Mountain View, CA",
      zip_code: "94043"
    }
  end

  # rubocop:disable RSpec/VerifiedDoubleReference
  let(:successful_provider) do
    instance_double("GeoProvider", reverse_geocode: valid_result)
  end

  let(:failing_provider) do
    instance_double("GeoProvider", reverse_geocode: nil)
  end
  # rubocop:enable RSpec/VerifiedDoubleReference

  describe ".reverse_geocode" do
    it "delegates to an instance and returns result" do
      result = described_class.reverse_geocode(latitude, longitude, providers: [ successful_provider ])
      expect(result).to eq(valid_result)
    end
  end

  describe "#reverse_geocode" do
    subject(:service) { described_class.new([ failing_provider, successful_provider ]) }

    context "when a provider returns a result" do
      it "returns formatted reverse geocoding result" do
        expect(service.reverse_geocode(latitude, longitude)).to eq(valid_result)
      end
    end

    context "when all providers fail" do
      subject(:service) { described_class.new([ failing_provider ]) }

      it "returns nil" do
        expect(service.reverse_geocode(latitude, longitude)).to be_nil
      end
    end

    context "when coordinates are invalid" do
      it "returns nil" do
        expect(service.reverse_geocode(nil, nil)).to be_nil
      end
    end

    context "when provider raises an error" do
      # rubocop:disable RSpec/VerifiedDoubleReference
      let(:error_provider) do
        instance_double("GeoProvider").tap do |prov|
          allow(prov).to receive(:reverse_geocode).and_raise("Boom")
        end
      end
      # rubocop:enable RSpec/VerifiedDoubleReference

      it "rescues and logs, then continues to next provider" do
        allow(Rails.logger).to receive(:error)

        service = described_class.new([ error_provider, successful_provider ])
        result = service.reverse_geocode(latitude, longitude)

        expect(result).to eq(valid_result)
        expect(Rails.logger).to have_received(:error).with(/Boom/)
      end
    end
  end
end
