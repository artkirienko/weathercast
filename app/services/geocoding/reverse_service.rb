module Geocoding
  class ReverseService
    def self.reverse_geocode(latitude, longitude, providers: default_providers)
      new(providers).reverse_geocode(latitude, longitude)
    end

    def initialize(providers)
      @providers = providers
    end

    def reverse_geocode(latitude, longitude)
      return nil unless valid_coordinates?(latitude, longitude)

      @providers.each do |provider|
        result = provider.reverse_geocode(latitude, longitude)
        return format_result(result) if result
      rescue StandardError => e
        Rails.logger.error "Reverse geocoding failed with provider #{provider.class}: #{e.message}"
        next
      end

      Rails.logger.error "Reverse geocoding failed for coordinates (#{latitude}, #{longitude}) after all provider attempts"
      nil
    end

    private

    def self.default_providers
      [
        Providers::Nominatim.new,
        Providers::Geoapify.new
        # Add Providers::OpenWeatherMap.new when implemented
      ]
    end

    def valid_coordinates?(latitude, longitude)
      latitude.is_a?(Numeric) && longitude.is_a?(Numeric) &&
        latitude.between?(-90, 90) && longitude.between?(-180, 180)
    end

    def format_result(result)
      {
        address: result[:address],
        zip_code: result[:zip_code]
      }
    end
  end
end
