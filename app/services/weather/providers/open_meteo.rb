module Weather
  module Providers
    # Weather provider for the Open-Meteo API
    # Currently a placeholder with no implementation
    class OpenMeteo < Base
      # Initializes the Open-Meteo provider
      # Currently sets a placeholder client
      #
      # @return [void]
      def initialize
        # Initialize Open-Meteo client when implemented
        @client = nil # Placeholder
      end

      # Fetches weather data for the given coordinates
      #
      # @param latitude [Float] the latitude coordinate
      # @param longitude [Float] the longitude coordinate
      # @return [Hash, nil] weather data or nil
      # @raise [NotImplementedError] always, since not yet implemented
      def fetch_weather(latitude, longitude)
        raise NotImplementedError, "Weather fetching not implemented for Open-Meteo"
      end
    end
  end
end
