module Geocoding
  module Providers
    class OpenWeatherMap < Base
      def initialize
        @api_key = Secrets.fetch(:openweathermap_api_key)
      end

      def geocode(address)
        raise NotImplementedError, "Geocoding not implemented for OpenWeatherMap"
      end

      def reverse_geocode(latitude, longitude)
        raise NotImplementedError, "Reverse geocoding not implemented for OpenWeatherMap"
      end
    end
  end
end
