class ForecastsController < ApplicationController
  def show
    result = Forecasts::FetchService.fetch_forecast(params[:address])

    @error = result[:error]
    @address = result[:address]
    @forecast = result[:forecast]
    @cached_at = result[:cached_at]
    @cached = result[:cached]
    @raw_address = result[:raw_address]
  end
end
