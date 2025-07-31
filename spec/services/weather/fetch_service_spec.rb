# frozen_string_literal: true

require "rails_helper"

RSpec.describe Weather::FetchService, :vcr do
  let(:latitude) { 49.2827 }
  let(:longitude) { -123.1207 }
  let(:valid_provider) { Weather::Providers::OpenWeather.new }
  let(:failing_provider) do
    Class.new do
      def fetch_weather(_, _)
        raise "Simulated failure"
      end
    end.new
  end

  describe ".fetch_weather" do
    it "delegates to instance method and returns data" do
      result = described_class.fetch_weather(latitude, longitude, providers: [ valid_provider ])
      expect(result).to include(:current_temperature, :extended_forecast)
    end
  end

  describe "#fetch_weather" do
    it "returns first successful result when some providers fail" do
      result = described_class.new([ failing_provider, valid_provider ])
                               .fetch_weather(latitude, longitude)
      expect(result).to include(:current_temperature)
    end

    it "returns nil when all providers fail" do
      all_fail_provider = Class.new do
        def fetch_weather(_, _); raise "fail"; end
      end.new

      logger_spy = instance_spy(Logger)
      allow(Rails).to receive(:logger).and_return(logger_spy)

      result = described_class.new([ all_fail_provider ]).fetch_weather(latitude, longitude)

      expect(logger_spy).to have_received(:error).at_least(:once)
      expect(result).to be_nil
    end

    it "returns nil for invalid coordinates" do
      result = described_class.new([ valid_provider ]).fetch_weather(nil, nil)
      expect(result).to be_nil
    end
  end
end
