module Weather
  module Providers
    # Weather provider for the OpenWeather API
    # Uses an OpenWeather client to fetch current weather and forecast data
    class OpenWeather < Base
      # Initializes the OpenWeather provider with an API key and client
      #
      # @return [void]
      def initialize
        @api_key = Secrets.fetch(:openweathermap_api_key)
        @client = ::OpenWeather::Client.new(api_key: @api_key)
      end

      # Fetches current weather and extended forecast for given coordinates
      #
      # @param latitude [Float] the latitude coordinate
      # @param longitude [Float] the longitude coordinate
      # @return [Hash, nil] a hash with current temperature data and extended forecast,
      #   or nil if fetching fails
      def fetch_weather(latitude, longitude)
        current = fetch_current_weather(latitude, longitude)
        forecast = fetch_forecast(latitude, longitude)
        return nil unless current && forecast

        parse_weather_entry(current, current_temperature: true).merge!(extended_forecast: parse_forecast(forecast))
      rescue StandardError => e
        Rails.logger.error "OpenWeather API error: #{e.message}"
        nil
      end

      private

      # Fetches the current weather from the OpenWeather client
      #
      # @param latitude [Float]
      # @param longitude [Float]
      # @return [Object] the current weather data response
      def fetch_current_weather(latitude, longitude)
        @client.current_weather(lat: latitude, lon: longitude)
      end

      # Fetches the five-day forecast from the OpenWeather client
      #
      # @param latitude [Float]
      # @param longitude [Float]
      # @return [Object] the forecast data response
      def fetch_forecast(latitude, longitude)
        @client.five_day_forecast(lat: latitude, lon: longitude)
      end
    end
  end
end
