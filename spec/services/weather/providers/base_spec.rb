# frozen_string_literal: true

require "ostruct"
require "rails_helper"

RSpec.describe Weather::Providers::Base do
  let(:dummy_class) { Class.new(described_class) }

  describe "#parse_weather_entry" do
    it "parses entry with current temp" do
      entry = OpenStruct.new(main: OpenStruct.new(temp_c: 10, temp_f: 50, temp_min_c: 8, temp_max_c: 12, temp_min_f: 46.4, temp_max_f: 53.6))
      result = dummy_class.new.send(:parse_weather_entry, entry, current_temperature: true)

      expect(result).to include(:current_temperature, :low, :high)
    end
  end

  describe "#parse_forecast" do
    it "aggregates multi-day data" do
      entry = ->(temp_min, temp_max, day) {
        OpenStruct.new(
          dt: Time.now.to_date + day,
          main: OpenStruct.new(
            temp_min_c: temp_min,
            temp_max_c: temp_max,
            temp_min_f: temp_min * 1.8 + 32,
            temp_max_f: temp_max * 1.8 + 32
          )
        )
      }

      forecast = OpenStruct.new(list: [
        entry.call(10, 15, 0), entry.call(8, 16, 0), entry.call(7, 14, 1)
      ])

      result = dummy_class.new.send(:parse_forecast, forecast)

      expect(result.length).to eq(2)
      expect(result.first).to include(:date, :low, :high)
    end
  end
end
