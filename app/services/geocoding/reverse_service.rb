module Geocoding
  # Service responsible for performing reverse geocoding (coordinates → address)
  # Attempts reverse geocoding using a list of provider instances until one succeeds
  class ReverseService
    include GeoUtils

    # Performs reverse geocoding using a list of providers
    #
    # @param latitude [Float] the latitude coordinate
    # @param longitude [Float] the longitude coordinate
    # @param providers [Array<Object>] list of provider instances (must respond to `#reverse_geocode`)
    # @return [Hash, nil] a hash with :address and :zip_code, or nil if all providers fail
    def self.reverse_geocode(latitude, longitude, providers: default_providers)
      new(providers).reverse_geocode(latitude, longitude)
    end

    # Initializes the service with the given list of providers
    #
    # @param providers [Array<Object>] the reverse geocoding providers to use
    def initialize(providers)
      @providers = providers
    end

    # Attempts to reverse geocode the given coordinates using the configured providers
    #
    # @param latitude [Float] the latitude value
    # @param longitude [Float] the longitude value
    # @return [Hash, nil] a hash with :address and :zip_code, or nil if all providers fail
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

    # Returns the default list of reverse geocoding providers
    #
    # @return [Array<Object>] array of default provider instances
    def self.default_providers
      [
        Providers::Nominatim.new,
        Providers::Geoapify.new
        # Add Providers::OpenWeatherMap.new when implemented
      ]
    end

    # Normalizes the result returned by a reverse geocoding provider
    #
    # @param result [Hash] the raw result from the provider
    # @return [Hash] formatted hash with keys :address and :zip_code
    def format_result(result)
      {
        address: result[:address],
        zip_code: result[:zip_code]
      }
    end
  end
end
