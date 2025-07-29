class ForecastsController < ApplicationController
  def show
    @address = params[:address]

    if @address.blank? && params.key?(:button)
      flash.now[:notice] = "Please enter an address to get the forecast."
      # If you render a form here, wrap it in the same Turbo Frame ID.
      # For now, we'll just show a message inside the frame.
    elsif @address.blank?
      # do nothing, just render the form
    elsif !valid_address_format?(@address)
      flash.now[:alert] = "The provided address has an invalid format. Please try again."
    else
      begin
        # Simulate fetching forecast data
        Rails.logger.info "Simulating 2-second delay before fetching forecast for #{@address}..."
        sleep 2
        @forecast_data = {
          location: @address,
          temperature: rand(10..30), # Random temp between 10 and 30
          conditions: [ "Sunny", "Cloudy", "Rainy", "Partly Cloudy" ].sample,
          wind_speed: rand(5..20)
        }
      rescue StandardError => e
        flash.now[:alert] = "Could not fetch forecast for '#{@address}': #{e.message}"
      end
    end
  end

  private

  def valid_address_format?(address)
    address.is_a?(String) && address.length.between?(3, 100) && address.match?(/\A[a-zA-Z0-9\s,.\-]+\z/)
  end
end
