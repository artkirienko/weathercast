# frozen_string_literal: true

require "rails_helper"

RSpec.describe Weather::Providers::OpenWeather, :vcr do
  let(:provider) { described_class.new }
  let(:latitude) { 49.2827 }
  let(:longitude) { -123.1207 }

  describe "#fetch_weather" do
    it "returns current temperature and extended forecast" do
      result = provider.fetch_weather(latitude, longitude)

      expect(result).to include(:current_temperature, :extended_forecast)
      expect(result[:extended_forecast]).to all(include(:date, :low, :high))
    end

    it "returns nil and logs error when OpenWeather fails" do
      client = instance_double(OpenWeather::Client)
      allow(OpenWeather::Client).to receive(:new).and_return(client)
      allow(client).to receive(:current_weather).and_raise(StandardError, "oops")

      logger_spy = instance_spy(Logger)
      allow(Rails).to receive(:logger).and_return(logger_spy)

      result = provider.fetch_weather(latitude, longitude)

      expect(result).to be_nil
      expect(logger_spy).to have_received(:error).with(/OpenWeather API error/)
    end
  end
end
