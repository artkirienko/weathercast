require 'rails_helper'

RSpec.describe WeatherService do
  let(:service) { described_class.new }
  let(:address) { "New York, NY" }

  describe "#fetch_weather" do
    context "when address is valid" do
      before do
        allow(Geocoder).to receive(:coordinates).and_return([ 40.7128, -74.0060 ])
      end

      it "returns weather data" do
        VCR.use_cassette("weather_service/valid_address") do
          result = service.fetch_weather(address)
          expect(result).to include(:temperature, :high, :low, :description)
          expect(result[:cached]).to be false
        end
      end

      it "caches the result" do
        VCR.use_cassette("weather_service/valid_address") do
          service.fetch_weather(address)
          result = service.fetch_weather(address)
          expect(result[:cached]).to be true
        end
      end
    end

    context "when address is invalid" do
      before do
        allow(Geocoder).to receive(:coordinates).and_return(nil)
      end

      it "returns nil" do
        expect(service.fetch_weather("Invalid Address")).to be_nil
      end
    end
  end
end
