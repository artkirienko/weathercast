# frozen_string_literal: true

module Geocoding
  # Interface module for geocoding providers
  # Any class including this module must implement `#geocode` and `#reverse_geocode` methods
  module Provider
    # Performs forward geocoding
    #
    # @param address [String] the address to geocode
    # @return [Hash, nil] a hash with geocoding result (e.g., :latitude, :longitude, :zip_code), or nil
    # @raise [NotImplementedError] if not implemented by the including class
    def geocode(address)
      raise NotImplementedError, "#{self.class} must implement #geocode"
    end

    # Performs reverse geocoding
    #
    # @param latitude [Float] the latitude coordinate
    # @param longitude [Float] the longitude coordinate
    # @return [Hash, nil] a hash with reverse geocoding result, or nil
    # @raise [NotImplementedError] if not implemented by the including class
    def reverse_geocode(latitude, longitude)
      raise NotImplementedError, "#{self.class} must implement #reverse_geocode"
    end
  end
end
