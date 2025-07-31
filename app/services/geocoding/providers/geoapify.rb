module Geocoding
  module Providers
    # Geocoding provider for the Geoapify API
    # Supports forward geocoding using the Geocoder gem
    class Geoapify < Base
      RESULT_LIMIT = 2

      # Initializes the Geoapify provider with the API key from secrets
      #
      # @return [void]
      def initialize
        @api_key = Secrets.fetch(:geocoder_geoapify_api_key)
      end

      # Performs forward geocoding for the given address
      #
      # @param address [String] the address to geocode
      # @return [Hash, nil] a hash with :latitude, :longitude, and :zip_code,
      #   or nil if geocoding fails
      def geocode(address)
        configure_geocoder(
          lookup: :geoapify,
          api_key: @api_key,
          limit: RESULT_LIMIT
        )
        result = Geocoder.search(address)&.first
        format_result(result) if result
      rescue StandardError => e
        Rails.logger.error "Geoapify geocoding failed: #{e.message}"
        nil
      end

      # Reverse geocoding is not implemented for Geoapify
      #
      # @param latitude [Float]
      # @param longitude [Float]
      # @raise [NotImplementedError] always
      def reverse_geocode(latitude, longitude)
        raise NotImplementedError, "Reverse geocoding not implemented for Geoapify"
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
