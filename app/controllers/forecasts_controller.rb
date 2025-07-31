class ForecastsController < ApplicationController
  def show
    @raw_address = params[:address]&.squish
    @error = nil

    if @raw_address.blank? && params.key?(:commit)
      @error = "Please enter an address to get the forecast."
    elsif @raw_address.blank?
      # do nothing, just render the form
    elsif !valid_address_format?(@raw_address)
      @error = "The provided address has an invalid format. Please try again."
    else
      begin
        @address = Address.new(raw_address: @raw_address)

        # cache address by raw_address -> geocode -> zip_code, lat, long
        @address, _cached_at, _cached = CacheService.fetch(Address, :raw_address, @address.raw_address) do
          if (@geocode = GeocodingService.geocode(@address.raw_address))
            @address.latitude = @geocode&.dig(:latitude)
            @address.longitude = @geocode&.dig(:longitude)
            @address.zip_code = @geocode&.dig(:zip_code)
            @address
          else
            raise "Geocoding failed for address: #{@address.raw_address}"
          end
        end

        # cache address by zip_code -> lat, long
        @address, _cached_at, _cached = CacheService.fetch(Address, :zip_code, @address.zip_code) do
          @address
        end

        # cache forecast by zip_code -> forecast data
        @forecast, @cached_at, @cached = CacheService.fetch(Forecast, :zip_code, @address.zip_code) do
          if (@data = WeatherService.fetch_weather(@address.latitude, @address.longitude))
            Forecast.new(zip_code: @address.zip_code, data: @data)
          else
            raise "Weather data fetch failed for lat: #{@address.latitude} long: #{@address.longitude} zip_code: #{@address.zip_code}"
          end
        end

        @error = "Could not fetch forecast for '#{@raw_address}'. Please try again later." if @forecast.nil?
      rescue StandardError => e
        @error = "Could not fetch forecast for '#{@raw_address}': #{e.message}"
      end
    end
  end

  private

  # candidate to move to a model validation
  def valid_address_format?(address)
    return false unless address.is_a?(String)
    return false unless address.length.between?(3, 100)

    address.match?(/\A[a-zA-Z0-9\s,.\-]+\z/)
  end
end
