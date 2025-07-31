module Geocoding
  module Providers
    # Base class for geocoding providers
    # Includes shared configuration logic for provider implementations
    class Base
      include Provider

      private

      # Configures the Geocoder gem with the given provider options
      #
      # @param options [Hash] configuration options for the geocoder
      # @option options [Symbol] :lookup the geocoding service symbol (e.g., :google, :nominatim)
      # @option options [String] :api_key the API key for the geocoding service
      # @option options [Hash] :http_headers optional HTTP headers
      # @option options [Integer] :limit optional query limit
      #
      # @return [void]
      def configure_geocoder(options)
        Geocoder.configure(
          lookup: options[:lookup],
          api_key: options[:api_key],
          http_headers: options[:http_headers] || {},
          always_raise: [],
          limit: options[:limit]
        )
      end
    end
  end
end
