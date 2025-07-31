require 'rails_helper'

RSpec.describe Geocoding::Providers::Nominatim, type: :service do
  subject(:provider) { described_class.new }

  describe "#geocode", :vcr do
    it "returns a hash with latitude, longitude, and zip_code" do
      result = provider.geocode("1 Infinite Loop, Cupertino, CA 95014, USA")

      expect(result).to include(:latitude, :longitude, :zip_code)
      expect(result[:latitude]).to be_a(Float)
      expect(result[:longitude]).to be_a(Float)
    end
  end

  describe "#reverse_geocode" do
    it "raises NotImplementedError" do
      expect {
        provider.reverse_geocode(48.8566, 2.3522)
      }.to raise_error(NotImplementedError)
    end
  end
end
