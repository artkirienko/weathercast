[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/artkirienko/weathercast/issues)
[![GitHub Actions CI](https://github.com/artkirienko/weathercast/actions/workflows/ci.yml/badge.svg)](https://github.com/artkirienko/weathercast/actions/workflows/ci.yml)
[![SLOC](https://sloc.xyz/github/artkirienko/weathercast)](https://en.wikipedia.org/wiki/Source_lines_of_code)
[![Hits-of-Code](https://hitsofcode.com/github/artkirienko/weathercast?branch=main)](https://hitsofcode.com)
[![HitCount](https://hitscounter.dev/api/hit?url=https%3A%2F%2Fgithub.com%2Fartkirienko%2Fweathercast&label=Visitors&icon=heart-fill&color=%23d1e7dd)](https://hitscounter.dev)

# Ruby Coding Assessment Weather App ⛅️

A Ruby on Rails application that retrieves and displays weather forecasts based on user-provided addresses, with caching for performance optimization

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Assumptions](#assumptions)
- [Submission](#submission)
- [Architecture Overview](#architecture-overview)
- [Design Patterns](#design-patterns)
- [Scalability Considerations](#scalability-considerations)
- [Probable Future Features](#probable-future-features)
- [Getting Started](#getting-started)
  - [Dev Containers (Recommended)](#dev-containers-recommended)
  - [Local Setup](#local-setup)
- [Running Tests](#running-tests)
- [Deployment](#deployment)

## Features

- Accepts an address as input (e.g., `1 Infinite Loop, Cupertino, CA 95014, United States`)
- Retrieves forecast data for the given address, including current temperature (optionally high/low and extended forecast)
- Displays forecast details to the user
- Caches forecast details for 30 minutes by zip code, with a cache-hit indicator

## Requirements

- Ruby on Rails
- Accept address input
- Retrieve and display weather forecast (current temperature required; high/low or extended forecast is a bonus)
- Cache forecast results for 30 minutes by zip code, with cache-hit indicator

## Assumptions

- Functionality is prioritized over form
- Open to interpretation
- Complete as much as possible if stuck

## Submission

- Use a public source code repository (e.g., GitHub)
- Share the repository link upon completion

## Architecture Overview

- `ForecastsController`: Handles requests and renders the forecast view
- `Address` and `Forecast` models: Manage validations and form interactions
- `Forecasts::FetchService`: Orchestrates the workflow from address input to weather result
- `Geocoding` module: Provides geocoding and reverse geocoding with multiple providers and fallback
- `Weather` module: Fetches weather data for coordinates, supports multiple providers and fallback
- `CacheService`: Universal caching and retrieval with TTL using Rails cache

## Design Patterns

- **Service Pattern**: Encapsulates business logic (geocoding, weather API, caching) in service classes for modularity and testability
- **Adapter Pattern**: Integrates external APIs (weather, maps) via adapters to unify interfaces and decouple dependencies
- **Strategy Pattern**: Encapsulates interchangeable algorithms (e.g., temperature conversion, data formatting, caching policies) for flexibility and separation of concerns

## Scalability Considerations

- Caching with Redis enables horizontal scalability
- Geocoding may not always return a zip code (e.g., city/state only input)
- Geospatial or radius-based caching could improve cache hit rates
- Consider implementing other Rails caching strategies: https://guides.rubyonrails.org/caching_with_rails.html

## Probable Future Features

- Application monitoring (Sentry, DataDog, HoneyBadger)
- Additional weather API adapters
- Address autocomplete
- Share/bookmark current forecast URL
- Improved error handling and user-friendly error messages
- Accessibility improvements

## 🚀 Getting Started

### Dev Containers (Recommended)

1. Install Docker (Docker, Podman, or OrbStack)
2. Install the Dev Containers extension (if using VS Code)
3. Open the project directory and select "Re-open in dev container" when prompted

### Local Setup

- Ruby version: 3.4.4
- System dependencies: SQLite, Redis (production only)
- Required environment variables:
  ```shell
  RAILS_MASTER_KEY
  GEOCODER_DEFAULT_EMAIL
  GEOCODER_GEOAPIFY_API_KEY
  OPENWEATHERMAP_API_KEY
  ```
- Database setup:
  ```shell
  bin/rails db:create db:setup
  ```

## Running Tests

```shell
RAILS_ENV=test bin/rspec
```

## Deployment

- Deployed to Render: [https://weather-di4k.onrender.com](https://weather-di4k.onrender.com)

[![Deployed to render.com](https://weather-di4k.onrender.com/1x1-spinup-render-com.png)](https://weather-di4k.onrender.com)

---

Built with ❤️ by [Artem Kirienko](https://github.com/artkirienko). *_100% Human-made, No AI involved_ © 2025
