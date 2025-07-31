module Weather
  module Providers
    # Base class for weather data providers
    # Includes shared logic for parsing temperature and forecast data from API responses
    class Base
      include Provider

      protected

      # Parses a single weather entry and extracts temperature data
      #
      # @param entry [Object] the raw weather entry (e.g., from an API like OpenWeatherMap)
      # @param current_temperature [Boolean] whether to include current temperature instead of daily min/max
      # @return [Hash] a hash containing temperature information, e.g.:
      #   {
      #     date: <timestamp>,
      #     low: { c: <temp_min_c>, f: <temp_min_f> },
      #     high: { c: <temp_max_c>, f: <temp_max_f> },
      #     current_temperature: { c: <temp_c>, f: <temp_f> } # if current_temperature is true
      #   }
      def parse_weather_entry(entry, current_temperature: false)
        res = {}
        res.merge!(date: entry&.dt) unless current_temperature
        res.merge!(current_temperature: {
          c: entry&.main&.temp_c,
          f: entry&.main&.temp_f
        }) if current_temperature
        res.merge!(
          low: {
            c: entry&.main&.temp_min_c,
            f: entry&.main&.temp_min_f
          },
          high: {
            c: entry&.main&.temp_max_c,
            f: entry&.main&.temp_max_f
          }
        )
        res
      end

      # Parses a multi-day weather forecast and aggregates daily high/low temperatures
      #
      # @param forecast [Object] the forecast object, expected to respond to `#list`
      # @return [Array<Hash>] an array of daily summaries, each with:
      #   {
      #     date: <Date>,
      #     low: { c: <min_temp_c>, f: <min_temp_f> },
      #     high: { c: <max_temp_c>, f: <max_temp_f> }
      #   }
      def parse_forecast(forecast)
        forecast.list.group_by { |item| item&.dt&.to_date }.map do |date, items|
          low_c = items.map { |item| item&.main&.temp_min_c }.min
          high_c = items.map { |item| item&.main&.temp_max_c }.max
          low_f = items.map { |item| item&.main&.temp_min_f }.min
          high_f = items.map { |item| item&.main&.temp_max_f }.max
          {
            date: date&.to_date,
            low: { c: low_c, f: low_f },
            high: { c: high_c, f: high_f }
          }
        end
      rescue StandardError => e
        Rails.logger.error "Forecast parsing error: #{e.message}"
        []
      end
    end
  end
end
