class ForecastsController < ApplicationController
  def show
    @address = params[:address]&.strip
    @error = nil

    return if @address.blank? && !params.key?(:commit)

    if @address.blank?
      @error = "Please enter an address to get the forecast."
      return
    end

    unless valid_address_format?(@address)
      @error = "The provided address has an invalid format. Please use letters, numbers, spaces, commas, periods, or hyphens."
      return
    end

    begin
      @forecast_data = WeatherService.new(@address).fetch_forecast
    rescue WeatherService::NoForecastError
      @error = "No forecast found for \"#{@address}\". Please try a different address, city, or zip code."
    rescue StandardError => e
      @error = "Could not fetch forecast for \"#{@address}\": #{e.message}"
    end
  end

  private

  def valid_address_format?(address)
    return false unless address.is_a?(String)
    return false unless address.length.between?(3, 100)
    address.match?(/\A[a-zA-Z0-9\s,.\-]+\z/) && !address.match?(/[!@#$%^&*()_=+{}\[\]|\\:;"'<>?\/~`]+/)
  end
end
