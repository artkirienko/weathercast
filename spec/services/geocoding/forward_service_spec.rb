require 'rails_helper'

RSpec.describe Geocoding::ForwardService, type: :service do
  let(:address) { "1600 Amphitheatre Parkway, Mountain View, CA" }
  let(:valid_result) do
    {
      latitude: 37.4221,
      longitude: -122.0841,
      zip_code: "94043"
    }
  end

  # rubocop:disable RSpec/VerifiedDoubleReference
  let(:successful_provider) do
    instance_double("GeoProvider", geocode: valid_result)
  end

  let(:failing_provider) do
    instance_double("GeoProvider", geocode: nil)
  end
  # rubocop:enable RSpec/VerifiedDoubleReference

  describe ".geocode" do
    it "delegates to an instance and returns result" do
      result = described_class.geocode(address, providers: [ successful_provider ])
      expect(result).to eq(valid_result)
    end
  end

  describe "#geocode" do
    subject(:service) { described_class.new([ failing_provider, successful_provider ]) }

    context "when a provider returns a result" do
      it "returns formatted geocoding result" do
        expect(service.geocode(address)).to eq(valid_result)
      end
    end

    context "when all providers fail" do
      subject(:service) { described_class.new([ failing_provider ]) }

      it "returns nil" do
        expect(service.geocode(address)).to be_nil
      end
    end

    context "when address is blank" do
      it "returns nil" do
        expect(service.geocode("")).to be_nil
      end
    end

    context "when provider raises an error" do
      # rubocop:disable RSpec/VerifiedDoubleReference
      let(:error_provider) do
        instance_double("GeoProvider").tap do |prov|
          allow(prov).to receive(:geocode).and_raise("Boom")
        end
      end
      # rubocop:enable RSpec/VerifiedDoubleReference

      it "rescues and logs, then continues to next provider" do
        allow(Rails.logger).to receive(:error) # Stub logger for clean output

        service = described_class.new([ error_provider, successful_provider ])
        result = service.geocode(address)

        expect(result).to eq(valid_result)
        expect(Rails.logger).to have_received(:error).with(/Boom/)
      end
    end
  end
end
