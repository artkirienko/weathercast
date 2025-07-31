module Forecasts
  class FetchService
    def self.fetch_forecast(raw_address)
      new(raw_address).fetch_forecast
    end

    def initialize(raw_address)
      @raw_address = raw_address&.squish
    end

    def fetch_forecast
      return { error: "Please enter an address to get the forecast." } if @raw_address.blank?
      return { error: "The provided address has an invalid format. Please try again." } unless valid_address_format?

      address = fetch_address
      return { error: "Could not geocode address: #{@raw_address}" } unless address

      forecast, cached_at, cached = fetch_weather(address)
      return { error: "Could not fetch forecast for '#{@raw_address}'. Please try again later." } unless forecast

      {
        address: address,
        forecast: forecast,
        cached_at: cached_at,
        cached: cached,
        raw_address: @raw_address
      }
    rescue StandardError => e
      { error: "Could not fetch forecast for '#{@raw_address}': #{e.message} #{e.backtrace}" }
    end

    private

    def valid_address_format?
      return false unless @raw_address.is_a?(String)
      return false unless @raw_address.length.between?(3, 100)

      @raw_address.match?(/\A[a-zA-Z0-9\s,.\-]+\z/)
    end

    def fetch_address
      address, _cached_at, _cached = CacheService.fetch(Address, :raw_address, @raw_address) do
        geocode = Geocoding::ForwardService.geocode(@raw_address)
        return nil unless geocode

        Address.new(
          raw_address: @raw_address,
          latitude: geocode&.dig(:latitude),
          longitude: geocode&.dig(:longitude),
          zip_code: geocode&.dig(:zip_code)
        )
      end
      address
    end

    def fetch_weather(address)
      cache_key_type = address.zip_code.present? ? :zip_code : :lat_lon
      cache_key_value = address.zip_code.present? ? address.zip_code : "lat:#{address.latitude.round(5)},lon:#{address.longitude.round(5)}"

      CacheService.fetch(Forecast, cache_key_type, cache_key_value) do
        weather_data = Weather::FetchService.fetch_weather(address.latitude, address.longitude)
        return nil unless weather_data

        Forecast.new(zip_code: address.zip_code, data: weather_data)
      end
    end
  end
end
