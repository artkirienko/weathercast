# Stores cached weather forecast data for a zip code
#
# This model is a plain Ruby object using ActiveModel for validations and can be used
# to represent weather forecast data associated with a specific zip code
#
# @example Creating a forecast object
#   Forecast.new(
#     zip_code: "95014",
#     data: {
#       current_temperature: { c: 20, f: 68 },
#       extended_forecast: [...]
#     }
#   )
class Forecast
  include ActiveModel::Model
  attr_accessor :zip_code
  attr_accessor :data

  validates :data, presence: true
end
