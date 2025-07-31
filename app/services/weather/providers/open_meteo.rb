module Weather
  module Providers
    class OpenMeteo < Base
      def initialize
        # Initialize Open-Meteo client when implemented
        @client = nil # Placeholder
      end

      def fetch_weather(latitude, longitude)
        raise NotImplementedError, "Weather fetching not implemented for Open-Meteo"
      end
    end
  end
end
