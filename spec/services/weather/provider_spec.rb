# frozen_string_literal: true

require "rails_helper"

RSpec.describe Weather::Provider do
  let(:dummy_class) do
    Class.new { include Weather::Provider }
  end

  it "raises NotImplementedError when fetch_weather is not implemented" do
    expect {
      dummy_class.new.fetch_weather(0, 0)
    }.to raise_error(NotImplementedError)
  end
end
