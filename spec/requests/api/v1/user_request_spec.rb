require 'rails_helper'

RSpec.describe 'User requests', type: :request do
  describe 'POST /users' do
    it 'creates a new user' do
      user_params = { email: 'test@test.com', password: 'password', password_confirmation: 'password' }

      post '/api/v1/users', params: user_params

      expect(response).to have_http_status(:created)

      user = JSON.parse(response.body, symbolize_names: true)
      expect(user[:data][:attributes][:email]).to eq(user_params[:email])
    end

    it 'requires all fields' do
      user_params = { email: 'test@test.com', password: '', password_confirmation: 'password' }

      post '/api/v1/users', params: user_params

      expect(response).to have_http_status(:unprocessable_entity)
      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors].first[:message]).to eq("Password can't be blank")
    end

    it 'requires password to match password confirmation' do
      user_params = { email: 'test@test.com', password: 'wordpass', password_confirmation: 'password' }

      post '/api/v1/users', params: user_params

      expect(response).to have_http_status(:unprocessable_entity)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error[:errors].first[:message]).to eq("Password confirmation doesn't match Password")
    end
  end
end
