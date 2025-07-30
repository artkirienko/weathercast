class Address
  include ActiveModel::Model
  attr_accessor :zip_code, :latitude, :longitude, :raw_address
end
