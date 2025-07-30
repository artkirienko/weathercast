# Converts an address to geographic coordinates and zip code using the Geocoder gem with a fallback
# Converts geographic coordinates back to an address (not implemented in this service)
class GeocodingService
  def self.geocode(*args, **kwargs, &block)
    new.geocode(*args, **kwargs, &block)
  end

  def self.reverse_geocode(*args, **kwargs, &block)
    new.reverse_geocode(*args, **kwargs, &block)
  end

  def initialize
    @geocoder_default_email = Secrets.fetch(:geocoder_default_email, "myemail@icloud.com")
    @geocoder_geoapify_api_key = Secrets.fetch(:geocoder_geoapify_api_key)
  end

  # Performs geocoding with a fallback to Geoapify if the initial attempt fails
  def geocode(address)
    result = attempt_geocode(:default, address)
    result = attempt_geocode(:geoapify, address) if result.nil?

    return nil unless result

    {
      latitude: result.latitude,
      longitude: result.longitude,
      zip_code: result.postal_code
    }
  rescue StandardError => e
    Rails.logger.error "Geocoding failed after all attempts: #{e.message}"
    nil
  end

  def reverse_geocode(latitude, longitude)
    raise NotImplementedError, "Reverse geocoding is not implemented in this service."
  end

  private

  def attempt_geocode(lookup_type, address)
    configure_geocoder(lookup_type)
    result = Geocoder.search(address)&.first
    result if result
  rescue StandardError => e
    Rails.logger.error "Geocoding attempt (#{lookup_type}) failed: #{e.message}"
    nil
  end

  def configure_geocoder(lookup_type)
    # Reset Geocoder configuration to a clean state before applying new settings
    Geocoder.configure(
      lookup: :nominatim, # Default lookup for Geocoder gem
      api_key: nil,
      http_headers: {},
      always_raise: [],
    )

    case lookup_type
    when :default
      configure_default_geocoder
    when :geoapify
      configure_geoapify_geocoder
    else
      Rails.logger.warn "Unknown geocoder lookup type: #{lookup_type}. Using default configuration."
      configure_default_geocoder
    end
  end

  def configure_default_geocoder
    Geocoder.configure(
      http_headers: { "User-Agent" => @geocoder_default_email }
    )
  end

  def configure_geoapify_geocoder
    Geocoder.configure(
      lookup: :geoapify,
      api_key: @geocoder_geoapify_api_key,
      limit: 2
    )
  end
end
