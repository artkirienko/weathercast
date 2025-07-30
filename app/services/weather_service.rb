class WeatherService
  class NoForecastError < StandardError; end

  def initialize(address)
    @address = address
  end

  def fetch_forecast
    Rails.logger.info "Simulating 2-second delay before fetching forecast for #{@address}..."
    sleep 2

    # Simulate failure for certain conditions (e.g., specific invalid address)
    raise NoForecastError if @address.match?(/\A\d+\z/) && @address.length > 10

    {
      location: @address,
      temperature: rand(10..30),
      conditions: [ "Sunny", "Cloudy", "Rainy", "Partly Cloudy" ].sample,
      wind_speed: rand(5..20)
    }
  end
end
