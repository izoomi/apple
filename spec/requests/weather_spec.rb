require 'rails_helper'

RSpec.describe "Weathers", type: :request do
  describe "GET /home" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /search" do
    context 'with no params' do
      it "returns http success and gives a flash message" do
        get "/weather/search"
        expect(response).to have_http_status(:success)
        expect(flash[:alert]).to eq('There was a problem finding your location. Please try again.')
      end
    end

    context 'with valid address', :vcr do
      context 'when there are no errors' do
        before do
          get "/weather/search", params: { address: '300 Post St, San Francisco, CA 94108' }
        end

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "displays the weather for the address" do
          expect(response.body).to include('Apple Union Square, 300, Post Street, Union Square, San Francisco, California, 94108')
          expect(response.body).to include('76.24')
          expect(response.body).to include('58.28')
          expect(response.body).to include('52.29')
        end
      end

      context 'when there is a open weather error' do
        it "returns http success and gives a flash message" do
          allow_any_instance_of(OpenWeather::Client).to receive(:current_weather).and_return({ 'cod' => 500 })
          get "/weather/search", params: { address: '300 Post St, San Francisco, CA 94108' }
          expect(response).to have_http_status(:success)
          expect(flash[:alert]).to eq('There was a problem retrieving the weather. Please try again.')
        end
      end
    end
  end
end
