# Represents a geocoded address with optional zip code, coordinates, and raw input
#
# This model is a plain Ruby object using ActiveModel for validations, form handling,
# and serialization compatibility, without being backed by a database
#
# @example Creating an address
#   Address.new(
#     raw_address: "1 Infinite Loop, Cupertino, CA 95014, United States",
#     latitude: 37.33182,
#     longitude: -122.03118,
#     zip_code: "95014"
#   )
class Address
  include ActiveModel::Model
  attr_accessor :zip_code, :latitude, :longitude, :raw_address
end
