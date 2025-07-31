module Weather
  module Providers
    class Base
      include Provider

      protected

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
