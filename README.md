[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/artkirienko/weathercast/issues)
[![GitHub Actions CI](https://github.com/artkirienko/weathercast/actions/workflows/ci.yml/badge.svg)](https://github.com/artkirienko/weathercast/actions/workflows/ci.yml)
[![SLOC](https://sloc.xyz/github/artkirienko/weathercast)](https://en.wikipedia.org/wiki/Source_lines_of_code)
[![Hits-of-Code](https://hitsofcode.com/github/artkirienko/weathercast?branch=main)](https://hitsofcode.com)
[![HitCount](https://hitscounter.dev/api/hit?url=https%3A%2F%2Fgithub.com%2Fartkirienko%2Fweathercast&label=Visitors&icon=heart-fill&color=%23d1e7dd)](https://hitscounter.dev)

# WeatherCast ⛅️

A Ruby on Rails weather forecasting application that delivers current and extended weather data based on user-provided addresses, optimized with caching for performance and scalability

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Design Patterns](#design-patterns)
- [Scalability Considerations](#scalability-considerations)
- [Future Enhancements](#future-enhancements)
- [Getting Started](#getting-started)
  - [Using Dev Containers (Recommended)](#using-dev-containers-recommended)
  - [Local Setup](#local-setup)
- [Running Tests](#running-tests)
- [Deployment](#deployment)

## Overview

WeatherCast is a robust, maintainable Ruby on Rails application designed to fetch and display weather forecasts for any given address. It prioritizes clean code, modularity, and performance through effective caching strategies. The app supports current temperature display, optional high/low and extended forecasts, and includes a user-friendly interface with cache-hit indicators

This project was developed as part of a coding assessment, emphasizing enterprise-grade practices such as unit testing, detailed documentation, and adherence to design patterns

## Features

- **Address Input**: Accepts full addresses (e.g., "1 Infinite Loop, Cupertino, CA 95014") or partial inputs (e.g., city/state)
- **Weather Data**: Retrieves current temperature, with optional high/low and 5-day extended forecasts
- **Caching**: Stores forecast data by zip code for 30 minutes to reduce API calls, with a cache-hit indicator in the UI
- **Responsive UI**: Simple, intuitive front-end for seamless user interaction
- **Error Handling**: Graceful handling of invalid inputs or API failures with user-friendly messages

## Tech Stack

- **Framework**: Ruby on Rails (v8.0.2)
- **Language**: Ruby (v3.4.4)
- **Database**: SQLite (development/test), PostgreSQL (production)
- **Caching**: Redis (production)
- **External APIs**:
  - Geocoding: Geoapify
  - Weather: OpenWeatherMap
- **Testing**: RSpec, FactoryBot
- **CI/CD**: GitHub Actions
- **Deployment**: Render.com

## Architecture

The application follows a modular, service-oriented architecture to ensure maintainability and testability:

- **Controllers**:
  - `ForecastsController`: Manages HTTP requests and renders forecast views
- **Models**:
  - `Address`: Validates and processes user-provided address inputs
  - `Forecast`: Stores and formats weather data for display
- **Services**:
  - `Forecasts::FetchService`: Orchestrates the workflow from address to weather result
  - `Geocoding::ForwardService`: Converts addresses to coordinates with fallback support
  - `Weather::FetchService`: Fetches weather data for given coordinates
  - `CacheService`: Handles caching with TTL using Rails cache
- **Modules**:
  - `Geocoding`: Abstracts geocoding logic with provider-agnostic interfaces
  - `Weather`: Abstracts weather data retrieval with provider-agnostic interfaces

This decomposition ensures encapsulation, reusability, and ease of swapping external providers

## Design Patterns

- **Service Pattern**: Encapsulates complex business logic (e.g., geocoding, weather fetching) in dedicated service classes for modularity and testability.
- **Adapter Pattern**: Normalizes external API responses (Geoapify, Nominatim, OpenWeatherMap, Open-Meteo) to a consistent internal format, decoupling the app from specific providers
- **Strategy Pattern**: Supports interchangeable algorithms (e.g., temperature units, caching policies) for flexibility

## Scalability Considerations

- **Caching**: Redis-backed caching reduces API calls and supports horizontal scaling. Zip code-based caching optimizes performance but may miss hits for partial address inputs (e.g., city-only)
- **Geocoding**: Fallback mechanisms handle API failures or missing zip codes, ensuring reliability
- **Future Improvements**:
  - Rate Limiting / Throttling
  - Geospatial caching (e.g., radius-based) to improve cache hit rates
  - Load balancing for high-traffic scenarios
  - Implementing more Rails caching strategies, see: [Ruby on Rails Caching Guide](https://guides.rubyonrails.org/caching_with_rails.html)

## Future Enhancements

- **Monitoring**: Integrate Sentry or DataDog for real-time error tracking and performance monitoring
- **API Adapters**: Support additional weather providers (e.g., Open-Meteo, Apple WeatherKit REST API)
- **Rate Limiting / Throttling**
- **UI/UX**:
  - Address autocomplete
  - Shareable/bookmarkable forecast URLs
  - Enhanced accessibility (ARIA labels, keyboard navigation)
- **Error Handling**: More granular user feedback for edge cases (e.g., ambiguous addresses)

## 🚀 Getting Started

### Using Dev Containers (Recommended)

1. Install Docker (e.g., Docker Desktop, Podman, or OrbStack)
2. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) for VS Code
3. Open the project in VS Code and select "Reopen in Container" when prompted

This setup ensures a consistent development environment with all dependencies pre-configured

### Local Setup

1. **Prerequisites**:
   - Ruby: 3.4.4
   - SQLite (development/test)
   - Redis (production caching)

2. **Clone the Repository**:
   ```shell
   git clone https://github.com/artkirienko/weathercast.git
   cd weathercast
   ```

3. **Install Dependencies**:
  ```shell
  bundle install
  ```

4. **Configure Environment Variables**:
  ```shell
  RAILS_MASTER_KEY=<your-master-key>
  GEOCODER_DEFAULT_EMAIL=<your-email>
  GEOCODER_GEOAPIFY_API_KEY=<geoapify-api-key>
  OPENWEATHERMAP_API_KEY=<openweathermap-api-key>
  ```

5. **Set Up Database**:
  ```shell
  bin/rails db:create db:setup
  ```

6. **Start the Server**:
  ```shell
  bin/rails server
  ```

Visit http://localhost:3000 in your browser.

### Running Tests

```shell
RAILS_ENV=test bin/rspec
```

### Deployment

The application is deployed on Render: [https://weather-di4k.onrender.com](https://weather-di4k.onrender.com)

[![Deployed to render.com](https://weather-di4k.onrender.com/1x1-spinup-render-com.png)](https://weather-di4k.onrender.com)

---

Built with ❤️ by [Artem Kirienko](https://github.com/artkirienko). *_100% Human-made, No AI involved_ © 2025
