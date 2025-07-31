module Geocoding
  module Providers
    class Nominatim < Base
      def initialize
        @email = Secrets.fetch(:geocoder_default_email, "myemail@icloud.com")
      end

      def geocode(address)
        configure_geocoder(
          lookup: :nominatim,
          http_headers: { "User-Agent" => @email }
        )
        result = Geocoder.search(address)&.first
        format_result(result) if result
      rescue StandardError => e
        Rails.logger.error "Nominatim geocoding failed: #{e.message}"
        nil
      end

      def reverse_geocode(latitude, longitude)
        raise NotImplementedError, "Reverse geocoding not implemented for Nominatim"
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
