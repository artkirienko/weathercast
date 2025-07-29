module Providers
  module Geo
    class GeocoderAdapter < ProviderInterface
      def coordinates(address)
        Geocoder.coordinates(address)
      end
    end
  end
end
