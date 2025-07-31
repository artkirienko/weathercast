# frozen_string_literal: true

module Weather
  # Service responsible for fetching weather data from multiple providers
  # Tries each provider in order until one returns a valid result
  class FetchService
    include GeoUtils

    # Fetches weather data for given coordinates using the specified providers
    #
    # @param latitude [Float] the latitude coordinate
    # @param longitude [Float] the longitude coordinate
    # @param providers [Array<Object>] list of weather provider instances
    # @return [Hash, nil] weather data from the first successful provider, or nil if all fail
    def self.fetch_weather(latitude, longitude, providers: default_providers)
      new(providers).fetch_weather(latitude, longitude)
    end

    # Initializes the fetch service with a list of providers
    #
    # @param providers [Array<Object>] the weather providers to use
    def initialize(providers)
      @providers = providers
    end

    # Attempts to fetch weather data using the configured providers
    #
    # @param latitude [Float] the latitude value
    # @param longitude [Float] the longitude value
    # @return [Hash, nil] the weather data or nil if all providers fail
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

    # Returns the default list of weather providers
    #
    # @return [Array<Object>] array of default provider instances
    def self.default_providers
      [
        Providers::OpenWeather.new
        # Add Providers::OpenMeteo.new when implemented
      ]
    end
  end
end
