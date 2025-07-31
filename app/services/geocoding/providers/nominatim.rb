module Geocoding
  module Providers
    # Geocoding provider using the open-source Nominatim API
    # Supports forward geocoding with a custom User-Agent header (email-based)
    class Nominatim < Base
      # Initializes the Nominatim provider with an email used as the User-Agent
      #
      # @return [void]
      def initialize
        @email = Secrets.fetch(:geocoder_default_email, "myemail@icloud.com")
      end

      # Performs forward geocoding for the given address
      #
      # @param address [String] the address to geocode
      # @return [Hash, nil] a hash with :latitude, :longitude, and :zip_code,
      #   or nil if geocoding fails
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

      # Reverse geocoding is not implemented for Nominatim
      #
      # @param latitude [Float]
      # @param longitude [Float]
      # @raise [NotImplementedError] always
      def reverse_geocode(latitude, longitude)
        raise NotImplementedError, "Reverse geocoding not implemented for Nominatim"
      end

      private

      # Formats a Geocoder result object into a simplified hash
      #
      # @param result [Geocoder::Result::Base] the raw result object
      # @return [Hash] a hash with keys :latitude, :longitude, and :zip_code
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
