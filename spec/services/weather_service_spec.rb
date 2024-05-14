require 'rails_helper'

RSpec.describe "WeatherService", type: :service do
  let(:weather_service) { WeatherService.new('300 Post St, San Francisco, CA 94108') }

  describe "initialize", :vcr do
    it "sets the location" do
      expect(weather_service.location).to be_an_instance_of(Geocoder::Result::Nominatim)
    end
  end

  describe "client", :vcr do
    it "returns an OpenWeather client" do
      expect(weather_service.client).to be_an_instance_of(OpenWeather::Client)
    end
  end

  describe "get_weather!", :vcr do
    it "fetches the weather" do
      expect(weather_service.client).to receive(:current_zip).with('94108', 'us').and_call_original
      weather_service.get_weather!
      expect(weather_service.instance_variable_get(:@weather_result)['cod']).to eq(200)
    end

    context 'when caching is enabled' do
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
      let(:cache) { Rails.cache }
      before do
        allow(Rails).to receive(:cache).and_return(memory_store)
        Rails.cache.clear
      end

      it "caches the weather result" do
        weather_service.get_weather!
        expect(weather_service.cached).to be(false)
        weather_service.get_weather!
        expect(weather_service.cached).to be(true)
      end
    end
  end

  describe "success?", :vcr do
    context 'when the weather result is successful' do
      it "returns true" do
        weather_service.get_weather!
        expect(weather_service.success?).to be(true)
      end
    end

    context 'when the weather result is not successful' do
      it "returns false" do
        allow_any_instance_of(OpenWeather::Client).to receive(:current_zip).and_return({ 'cod' => 500 })
        weather_service.get_weather!
        expect(weather_service.success?).to be(false)
      end
    end
  end

  describe "weather", :vcr do
    it "returns the weather" do
      weather_service.get_weather!
      expect(weather_service.weather.temp_f).to eq(52.43)
      expect(weather_service.weather.temp_min_f).to eq(48.99)
      expect(weather_service.weather.temp_max_f).to eq(58.71)
    end
  end
end
