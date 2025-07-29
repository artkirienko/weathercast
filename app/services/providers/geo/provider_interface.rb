module Providers
  module Geo
    class ProviderInterface
      def coordinates(address)
        raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
      end
    end
  end
end
