class WeatherController < ApplicationController
  def home
  end

  def search
    # geocode with Geocoder gem by address
    @location = Geocoder.search(params[:address]).first
    if @location.nil?
      flash[:alert] = 'There was a problem finding your location. Please try again.'
      render :home and return
    end
    client = OpenWeather::Client.new(
      api_key: 'bd5e378503939ddaee76f12ad7a97608'
    )
    @weather = client.current_weather(
      lat: @location.latitude,
      lon: @location.longitude
    )
    if @weather['cod'] == 200
      @temp = @weather['main'].temp_f
    else
      flash[:alert] = 'There was a problem retrieving the weather. Please try again.'
      render :home
    end
  end
end
