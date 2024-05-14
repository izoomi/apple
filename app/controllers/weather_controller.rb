class WeatherController < ApplicationController
  def home
  end

  def search
    @weather_service = WeatherService.new(params[:address])
    if @weather_service.location.nil?
      flash[:alert] = 'There was a problem finding your location. Please try again.'
      render :home and return
    end

    @weather_service.get_weather!
    if !@weather_service.success?
      flash[:alert] = 'There was a problem retrieving the weather. Please try again.'
      render :home
    end
  end
end
