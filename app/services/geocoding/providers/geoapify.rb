module Geocoding
  module Providers
    class Geoapify < Base
      def initialize
        @api_key = Secrets.fetch(:geocoder_geoapify_api_key)
      end

      def geocode(address)
        configure_geocoder(
          lookup: :geoapify,
          api_key: @api_key,
          limit: 2
        )
        result = Geocoder.search(address)&.first
        format_result(result) if result
      rescue StandardError => e
        Rails.logger.error "Geoapify geocoding failed: #{e.message}"
        nil
      end

      def reverse_geocode(latitude, longitude)
        raise NotImplementedError, "Reverse geocoding not implemented for Geoapify"
      end

      private

      def format_result(result)
        {
          latitude: result.latitude,
          longitude: result.longitude,
          zip_code: result.postal_code
        }
      end
    end
  end
end
