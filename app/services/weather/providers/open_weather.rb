module Weather
  module Providers
    class OpenWeather < Base
      def initialize
        @api_key = Secrets.fetch(:openweathermap_api_key)
        @client = ::OpenWeather::Client.new(api_key: @api_key)
      end

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

      def fetch_current_weather(latitude, longitude)
        @client.current_weather(lat: latitude, lon: longitude)
      end

      def fetch_forecast(latitude, longitude)
        @client.five_day_forecast(lat: latitude, lon: longitude)
      end
    end
  end
end
