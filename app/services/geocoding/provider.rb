module Geocoding
  module Provider
    def geocode(address)
      raise NotImplementedError, "#{self.class} must implement #geocode"
    end

    def reverse_geocode(latitude, longitude)
      raise NotImplementedError, "#{self.class} must implement #reverse_geocode"
    end
  end
end
