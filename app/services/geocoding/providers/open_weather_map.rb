module Geocoding
  module Providers
    # Placeholder geocoding provider for OpenWeatherMap
    # Currently does not implement geocoding or reverse geocoding functionality
    class OpenWeatherMap < Base
      # Initializes the OpenWeatherMap provider with the API key from secrets.
      #
      # @return [void]
      def initialize
        @api_key = Secrets.fetch(:openweathermap_api_key)
      end

      # Forward geocoding is not implemented for OpenWeatherMap
      #
      # @param address [String]
      # @raise [NotImplementedError] always
      def geocode(address)
        raise NotImplementedError, "Geocoding not implemented for OpenWeatherMap"
      end

      # Reverse geocoding is not implemented for OpenWeatherMap
      #
      # @param latitude [Float]
      # @param longitude [Float]
      # @raise [NotImplementedError] always
      def reverse_geocode(latitude, longitude)
        raise NotImplementedError, "Reverse geocoding not implemented for OpenWeatherMap"
      end
    end
  end
end
