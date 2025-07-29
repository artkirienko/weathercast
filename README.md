[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/artkirienko/weathercast/issues)
[![GitHub Actions CI](https://github.com/artkirienko/weathercast/actions/workflows/ci.yml/badge.svg)](https://github.com/artkirienko/weathercast/actions/workflows/ci.yml)
[![SLOC](https://sloc.xyz/github/artkirienko/weathercast)](https://en.wikipedia.org/wiki/Source_lines_of_code)
[![Hits-of-Code](https://hitsofcode.com/github/artkirienko/weathercast?branch=main)](https://hitsofcode.com)
[![HitCount](https://hitscounter.dev/api/hit?url=https%3A%2F%2Fgithub.com%2Fartkirienko%2Fweathercast&label=Visitors&icon=heart-fill&color=%23d1e7dd)](https://hitscounter.dev)

# WeatherCast ⛅️

A Ruby on Rails application that provides weather forecasts for any address, with built-in caching support.

## Features

- Address-based weather lookup
- Current temperature, high/low temperatures, and conditions
- 30-minute caching using Redis
- Clean, responsive UI using Bootstrap
- Comprehensive test coverage

## Requirements

- Ruby 3.x
- Rails 7.x
- PostgreSQL
- Redis

## Setup

1. Clone the repository
2. Install dependencies:
   ```bash
   bundle install
   ```
3. Set up environment variables:
   ```bash
   export OPENWEATHER_API_KEY=your_api_key
   export REDIS_URL=redis://localhost:6379/0
   ```
4. Start Redis server
5. Start Rails server:
   ```bash
   rails s
   ```

## Architecture

### Components

- `WeatherService`: Core service handling API interactions and caching
- `ForecastsController`: Manages user interactions and view rendering
- Redis: Caching layer for weather data

### Design Patterns

- Service Object Pattern: Encapsulates weather API logic
- Caching Strategy Pattern: Implements efficient data caching
- MVC Pattern: Standard Rails architecture

### Scalability Considerations

- Redis caching reduces API calls
- Geocoding results could be cached for frequently accessed locations
- API rate limiting handled gracefully
- Modular design allows for easy feature extension

## Testing

Run the test suite:
```bash
rails test
```

## Deployment

1. Ensure all environment variables are set
2. Precompile assets:
   ```bash
   rails assets:precompile
   ```
3. Migrate the database:
   ```bash
   rails db:migrate
   ```
4. Start the server:
   ```bash
   rails s
   ```

---

Built with ❤️ by [Artem Kirienko](https://github.com/artkirienko). *_100% Human-made, No AI involved_ © 2025
