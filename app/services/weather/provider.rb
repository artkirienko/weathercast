module Weather
  module Provider
    def fetch_weather(latitude, longitude)
      raise NotImplementedError, "#{self.class} must implement #fetch_weather"
    end
  end
end
