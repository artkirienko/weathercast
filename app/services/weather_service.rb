class WeatherService
  def self.fetch_weather(*args, **kwargs, &block)
    new.fetch_weather(*args, **kwargs, &block)
  end

  def initialize
    @api_key = Secrets.fetch(:openweathermap_api_key)
    @client = OpenWeather::Client.new(
      api_key: @api_key
    )
  end

  # Retrieves current weather and 5-day forecast
  def fetch_weather(latitude, longitude)
    current = fetch_current_weather(latitude, longitude)
    forecast = fetch_forecast(latitude, longitude)
    return nil unless current && forecast

    parse_weather_entry(current, current_temperature: true).merge!(extended_forecast: parse_forecast(forecast))
  rescue StandardError => e
    Rails.logger.error "Weather API error: #{e.message}"
    nil
  end

  private

  def fetch_current_weather(latitude, longitude)
    @client.current_weather(lat: latitude, lon: longitude)
  end

  def fetch_forecast(latitude, longitude)
    @client.five_day_forecast(lat: latitude, lon: longitude)
  end

  def parse_weather_entry(entry, current_temperature: false)
    res = {}
    res.merge!(date: entry&.dt) unless current_temperature
    res.merge!(current_temperature: {
      c: entry&.main&.temp_c,
      f: entry&.main&.temp_f
    }) if current_temperature
    res.merge!(
      {
        low: {
          c: entry&.main&.temp_min_c,
          f: entry&.main&.temp_min_f
        },
        high: {
          c: entry&.main&.temp_max_c,
          f: entry&.main&.temp_max_f
        }
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
    forecast.list.each_with_index.map { |entry, i| parse_weather_entry(entry) if (i % 8).zero? }&.compact&.first(5) || []
  rescue StandardError => e
    Rails.logger.error "Forecast parsing error: #{e.message}"
    []
  end
end
