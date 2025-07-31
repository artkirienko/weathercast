module Weather
  class FetchService
    def self.fetch_weather(latitude, longitude, providers: default_providers)
      new(providers).fetch_weather(latitude, longitude)
    end

    def initialize(providers)
      @providers = providers
    end

    def fetch_weather(latitude, longitude)
      return nil unless valid_coordinates?(latitude, longitude)

      @providers.each do |provider|
        result = provider.fetch_weather(latitude, longitude)
        return result if result
      rescue StandardError => e
        Rails.logger.error "Weather fetch failed with provider #{provider.class}: #{e.message}"
        next
      end

      Rails.logger.error "Weather fetch failed for coordinates (#{latitude}, #{longitude}) after all provider attempts"
      nil
    end

    private

    def self.default_providers
      [
        Providers::OpenWeather.new
        # Add Providers::OpenMeteo.new when implemented
      ]
    end

    def valid_coordinates?(latitude, longitude)
      latitude.is_a?(Numeric) && longitude.is_a?(Numeric) &&
        latitude.between?(-90, 90) && longitude.between?(-180, 180)
    end
  end
end
