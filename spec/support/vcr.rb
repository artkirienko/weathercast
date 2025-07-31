require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock, :faraday
  config.configure_rspec_metadata!
  config.default_cassette_options = { record: :once }
  # Ignore sensitive data (e.g., API keys) in recorded requests
  config.filter_sensitive_data('<API_KEY>') { ENV['GEOCODING_API_KEY'] }
  config.filter_sensitive_data('<WEATHER_API_KEY>') { ENV['WEATHER_API_KEY'] }
  config.filter_sensitive_data('<GEOCODER_GEOAPIFY_API_KEY>') { Secrets.fetch(:geocoder_geoapify_api_key) }
  config.filter_sensitive_data('<GEOCODER_DEFAULT_EMAIL>') { Secrets.fetch(:geocoder_default_email) }
  config.filter_sensitive_data('<OPENWEATHERMAP_API_KEY>') { Secrets.fetch(:openweathermap_api_key) }
end

RSpec.configure do |config|
  config.around(:each, :vcr) do |example|
    cassette_name = example.metadata[:full_description]
                      .gsub(/\s+/, "_")
                      .gsub(/[^\w\/]+/, "_")
                      .gsub(/\/$/, "")

    VCR.use_cassette(cassette_name) { example.run }
  end
end
