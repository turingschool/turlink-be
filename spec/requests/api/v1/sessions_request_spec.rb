require 'rails_helper'

RSpec.describe 'Sessions requests', type: :request do
  describe 'POST /sessions' do
    it 'logs in a existing user' do
      user = User.create(email: 'test@test.com', password: 'password', password_confirmation: 'password')

      post '/api/v1/sessions', params: { email: user.email, password: user.password }

      expect(response).to have_http_status(:ok)

      expect(session[:user_id]).to eq(user.id)

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:data][:attributes][:email]).to eq(user.email)
    end

    it 'does not log in a non-existing user' do
      post '/api/v1/sessions', params: { email: 'user@email.com', password: 'password' }

      expect(response).to have_http_status(:unauthorized)

      expect(session[:user_id]).to be_nil

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:errors].first[:message]).to eq('Invalid email or password')
    end

    it 'does not log in a user with wrong password' do
      user = User.create(email: 'test@test.com', password: 'password', password_confirmation: 'password')

      post '/api/v1/sessions', params: { email: user.email, password: 'passkey' }

      expect(response).to have_http_status(:unauthorized)

      expect(session[:user_id]).to be_nil

      response_body = JSON.parse(response.body, symbolize_names: true)

      expect(response_body[:errors].first[:message]).to eq('Invalid email or password')
    end
  end
end
