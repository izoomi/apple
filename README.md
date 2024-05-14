# Apple Rails Project

Requirements:
- Must be done in Ruby on Rails
- Accept an address as input
- Retrieve forecast data for the given address. This should include, at minimum, the
current temperature (Bonus points - Retrieve high/low and/or extended forecast)
- Display the requested forecast details to the user
-  Cache the forecast details for 30 minutes for all subsequent requests by zip codes.
- Display indicator if result is pulled from cache.

Assumptions:
- This project is open to interpretation
- Functionality is a priority over form
- If you get stuck, complete as much as you can

Submission:
- Use a public source code repository (GitHub, etc) to store your code
- Send us the link to your completed code

## Description

This project pulls from Open Weather API and uses the `geocoder` gem.


## Getting started

### Prerequisites

- Ruby

### Install

run `bundle install` to install gems.
normally would use a .env file for API key but this one was found online.

### Usage

- run the rails server: `rails s`
- enter a valid address and hit search
- will display current temp, along with high and low
- cache by zip code

### Testing

`bundle exec rspec spec`
