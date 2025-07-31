require 'rails_helper'

RSpec.describe Forecasts::FetchService, type: :service do
  describe '.fetch_forecast' do
    let(:raw_address) { 'Seattle, WA' }
    let(:full_address) { '123 Main St, Seattle, WA 98101' }
    let(:geocode_city) { { latitude: 47.6062, longitude: -122.3321, zip_code: nil } }
    let(:geocode_full) { { latitude: 47.6062, longitude: -122.3321, zip_code: '98101' } }
    let(:weather_data) { { temp: 65, condition: 'cloudy' } }

    before do
      allow(CacheService).to receive(:fetch).and_call_original
    end

    context 'with a city-only address (no zip_code)', vcr: { cassette_name: 'geocode_seattle_weather' } do
      it 'caches forecast by lat_lon' do
        allow(Geocoding::ForwardService).to receive(:geocode).with(raw_address).and_return(geocode_city)
        allow(Weather::FetchService).to receive(:fetch_weather).with(47.6062, -122.3321).and_return(weather_data)

        result = described_class.fetch_forecast(raw_address)

        expect(result[:error]).to be_nil
        expect(result[:forecast]).to be_present
        expect(result[:forecast].data).to eq(weather_data)
        expect(CacheService).to have_received(:fetch).with(
          Forecast,
          :lat_lon,
          'lat:47.6062,lon:-122.3321'
        )
      end
    end

    context 'with a full address (with zip_code)', vcr: { cassette_name: 'geocode_full_address_weather' } do
      it 'caches forecast by zip_code' do
        allow(Geocoding::ForwardService).to receive(:geocode).with(full_address).and_return(geocode_full)
        allow(Weather::FetchService).to receive(:fetch_weather).with(47.6062, -122.3321).and_return(weather_data)

        result = described_class.fetch_forecast(full_address)

        expect(result[:error]).to be_nil
        expect(result[:forecast]).to be_present
        expect(result[:forecast].data).to eq(weather_data)
        expect(CacheService).to have_received(:fetch).with(
          Forecast,
          :zip_code,
          '98101'
        )
      end
    end

    context 'with blank address' do
      it 'returns an error' do
        result = described_class.fetch_forecast('')
        expect(result[:error]).to eq('Please enter an address to get the forecast.')
      end
    end

    context 'with invalid address format' do
      it 'returns an error' do
        result = described_class.fetch_forecast('Seattle@WA')
        expect(result[:error]).to eq('The provided address has an invalid format. Please try again.')
      end
    end

    context 'when geocoding fails', vcr: { cassette_name: 'geocode_failure' } do
      it 'returns an error' do
        allow(Geocoding::ForwardService).to receive(:geocode).with(raw_address).and_return(nil)
        result = described_class.fetch_forecast(raw_address)
        expect(result[:error]).to eq("Could not geocode address: #{raw_address}")
      end
    end

    context 'when weather fetch fails', vcr: { cassette_name: 'weather_failure' } do
      it 'returns an error' do
        allow(Geocoding::ForwardService).to receive(:geocode).with(raw_address).and_return(geocode_city)
        allow(Weather::FetchService).to receive(:fetch_weather).with(47.6062, -122.3321).and_return(nil)
        result = described_class.fetch_forecast(raw_address)
        expect(result[:error]).to eq("Could not fetch forecast for '#{raw_address}'. Please try again later.")
      end
    end
  end
end
