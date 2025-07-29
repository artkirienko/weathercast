module Providers
  module Weather
    class ProviderInterface
      def fetch_weather(lat:, lon:)
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end
    end
  end
end
