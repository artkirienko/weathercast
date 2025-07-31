module Geocoding
  class ForwardService
    def self.geocode(address, providers: default_providers)
      new(providers).geocode(address)
    end

    def initialize(providers)
      @providers = providers
    end

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

    def self.default_providers
      [
        Providers::Nominatim.new,
        Providers::Geoapify.new
        # Add Providers::OpenWeatherMap.new when implemented
      ]
    end

    def format_result(result)
      {
        latitude: result[:latitude],
        longitude: result[:longitude],
        zip_code: result[:zip_code]
      }
    end
  end
end
