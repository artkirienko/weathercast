module Geocoding
  module Providers
    class Base
      include Provider

      private

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
