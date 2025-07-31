# Utility methods and constants for geographic coordinate validation
#
# @example
#   include GeoUtils
#   valid_coordinates?(37.3316, -122.0300) # => true
module GeoUtils
  LATITUDE_RANGE = -90..90
  LONGITUDE_RANGE = -180..180

  # Validates whether the given coordinates fall within acceptable ranges
  #
  # @param latitude [Numeric] The latitude value to check
  # @param longitude [Numeric] The longitude value to check
  # @return [Boolean] Whether the coordinates are valid
  def valid_coordinates?(latitude, longitude)
    latitude.is_a?(Numeric) && longitude.is_a?(Numeric) &&
      LATITUDE_RANGE.cover?(latitude) && LONGITUDE_RANGE.cover?(longitude)
  end
end
