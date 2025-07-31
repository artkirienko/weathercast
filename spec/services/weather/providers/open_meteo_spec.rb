# frozen_string_literal: true

require "rails_helper"

RSpec.describe Weather::Providers::OpenMeteo do
  it "raises NotImplementedError for fetch_weather" do
    provider = described_class.new
    expect {
      provider.fetch_weather(0, 0)
    }.to raise_error(NotImplementedError)
  end
end
