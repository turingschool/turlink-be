require 'rails_helper'

RSpec.describe 'User requests', type: :request do
  describe 'POST /users' do
    it 'creates a new user - happy path' do
      user_params = { email: 'test@test.com', password: 'password', password_confirmation: 'password' }

      post '/api/v1/users', params: { user: user_params }

      expect(response).to have_http_status(:created)

      user = JSON.parse(response.body, symbolize_names: true)
      expect(user[:data][:attributes][:email]).to eq(user_params[:email])
    end

    it 'requires all fields - sad path' do
      user_params = { email: 'test@test.com', password: '' }

      post '/api/v1/users', params: { user: user_params }

      expect(response).to have_http_status(:unprocessable_entity)

      error = JSON.parse(response.body, symbolize_names: true)

      expect(error.first[:status]).to eq("Password can't be blank")
    end
  end
end
