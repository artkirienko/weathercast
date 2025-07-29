class WeatherService
  CACHE_EXPIRY = 30.minutes

  def initialize(
    weather_provider: Providers::Weather::OpenWeatherAdapter.new(ENV["OPENWEATHER_API_KEY"]),
    geo_provider: Providers::Geo::GeocoderAdapter.new
  )
    @weather_provider = weather_provider
    @geo_provider = geo_provider
  end

  def fetch_weather(address)
    coordinates = @geo_provider.coordinates(address)
    return nil unless coordinates

    lat, lon = coordinates
    cache_key = "weather_#{coordinates.join('_')}"
    cached = $redis.get(cache_key)

    if cached
      JSON.parse(cached).merge(cached: true)
    else
      fetch_and_cache_weather(lat, lon, cache_key)
    end
  end

  private

  def fetch_and_cache_weather(lat, lon, cache_key)
    weather_data = @weather_provider.fetch_weather(lat: lat, lon: lon)
    weather_data[:cached] = false

    $redis.setex(cache_key, CACHE_EXPIRY, weather_data.to_json)
    weather_data
  end
end
