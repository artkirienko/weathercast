class ForecastsController < ApplicationController
  def index
  end

  def show
    @address = params[:address]
    if @address.present?
      @weather = WeatherService.new.fetch_weather(@address)
      flash.now[:error] = "Location not found" if @weather.nil?
    end
  end
end
