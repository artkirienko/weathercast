## Geocoding Module

The Geocoding module provides services for geocoding (converting addresses to geographic coordinates) and reverse geocoding (converting coordinates to addresses). It is designed to be modular, extensible, and robust, with support for multiple geocoding providers and a fallback strategy to ensure reliability

## Features

- Forward Geocoding: Converts addresses to coordinates (latitude, longitude, and zip code) using Geocoding::ForwardService
- Reverse Geocoding: Converts coordinates to addresses using Geocoding::ReverseService (currently a placeholder, to be implemented)
- Multiple Providers: Supports multiple geocoding providers (e.g., Nominatim, Geoapify) with a fallback mechanism
- Extensibility: Easily add new providers (e.g., OpenWeatherMap) by creating new provider classes
- Error Handling: Robust logging and fallback ensure graceful handling of API failures
- Configuration: Provider settings are managed via Rails credentials or environment variables

## Configuration

Provider API keys and settings are stored in Rails credentials or environment variables using Secrets.fetch. Configure the following:

```ruby
# config/credentials.yml.enc (or environment variables)
geocoder_default_email: "your-email@example.com" # Used for Nominatim's User-Agent
geocoder_geoapify_api_key: "your-geoapify-api-key" # Geoapify API key
open_weather_map_api_key: "your-openweathermap-api-key" # For future OpenWeatherMap provider
```

## Usage

### Forward Geocoding

Convert an address to coordinates and zip code:

```ruby
result = Geocoding::ForwardService.geocode("1 Infinite Loop, Cupertino, CA 95014, United States")
# => { latitude: 37.331, longitude: -122.030, zip_code: "95014" }
```

If the primary provider (Nominatim) fails, the service automatically falls back to Geoapify.

### Reverse Geocoding

Convert coordinates to an address (not yet implemented):

```ruby
result = Geocoding::ReverseService.reverse_geocode(37.331, -122.030)
# => Raises NotImplementedError or returns nil (to be implemented)
```

## Customizing Providers

You can override the default provider chain:

```ruby
custom_providers = [Geocoding::Providers::Geoapify.new, Geocoding::Providers::Nominatim.new]
result = Geocoding::ForwardService.geocode("123 Main St", providers: custom_providers)
```

## Adding a New Provider

To add a new provider (e.g., OpenWeatherMap Geocoding API), follow these steps:
- Create a new provider class in `app/services/geocoding/providers/`
- Add the provider to the default provider chain in ForwardService and ReverseService:

Ensure the provider’s API key is configured in Rails credentials
