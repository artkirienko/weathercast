module Geocoding
  # Service responsible for performing forward geocoding (address → coordinates)
  # Attempts geocoding using a list of provider instances until one succeeds
  class ForwardService
    # Performs forward geocoding using a list of providers
    #
    # @param address [String] the address to geocode
    # @param providers [Array<Object>] list of provider instances (must respond to `#geocode`)
    # @return [Hash, nil] a hash with :latitude, :longitude, and :zip_code,
    #   or nil if all providers fail
    def self.geocode(address, providers: default_providers)
      new(providers).geocode(address)
    end

    # Initializes the service with the given list of providers
    #
    # @param providers [Array<Object>] the geocoding providers to use
    def initialize(providers)
      @providers = providers
    end

    # Attempts to geocode the given address using the configured providers
    #
    # @param address [String] the input address
    # @return [Hash, nil] geocoded result or nil if all providers fail
    def geocode(address)
      return nil if address.blank?

      @providers.each do |provider|
        result = provider.geocode(address)
        return format_result(result) if result
      rescue StandardError => e
        Rails.logger.error "Geocoding failed with provider #{provider.class}: #{e.message}"
        next
      end

      Rails.logger.error "Geocoding failed for address '#{address}' after all provider attempts"
      nil
    end

    private

    # Returns the default list of geocoding providers
    #
    # @return [Array<Object>] array of default provider instances
    def self.default_providers
      [
        Providers::Nominatim.new,
        Providers::Geoapify.new
        # Add Providers::OpenWeatherMap.new when implemented
      ]
    end

    # Normalizes the result returned by a geocoding provider
    #
    # @param result [Hash] the raw result from the provider
    # @return [Hash] formatted hash with keys :latitude, :longitude, and :zip_code
    def format_result(result)
      {
        latitude: result[:latitude],
        longitude: result[:longitude],
        zip_code: result[:zip_code]
      }
    end
  end
end
