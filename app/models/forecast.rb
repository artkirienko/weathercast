# Stores cached weather forecast data for a zip code
class Forecast
  include ActiveModel::Model
  attr_accessor :zip_code, :data
  validates :data, presence: true
end
