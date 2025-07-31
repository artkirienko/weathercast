module Weather
  # Interface module for weather providers
  # Any class including this module must implement the `#fetch_weather` method
  module Provider
    # Fetches weather data for the given coordinates
    #
    # @param latitude [Float] the latitude coordinate
    # @param longitude [Float] the longitude coordinate
    # @return [Hash, nil] weather data hash or nil if unavailable
    # @raise [NotImplementedError] if the method is not implemented by the including class
    def fetch_weather(latitude, longitude)
      raise NotImplementedError, "#{self.class} must implement #fetch_weather"
    end
  end
end
