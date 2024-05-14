class WeatherService
  attr_accessor :location, :cached

  def initialize(address)
    @location = Geocoder.search(address).first
  end

  def client
    @client ||= OpenWeather::Client.new(
      api_key: 'bd5e378503939ddaee76f12ad7a97608'
    )
  end

  def get_weather!
    @cached = true
    @weather_result = Rails.cache.fetch("postal_code/#{@location.postal_code}", expires_in: 30.minutes) do
      @cached = false
      client.current_zip(@location.postal_code)
    end
  end

  def success?
    @weather_result['cod'] == 200
  end

  def weather
    @weather_result['main']
  end
end
