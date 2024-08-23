require 'rails_helper'

RSpec.describe 'links requests', type: :request do
  describe 'POST /users/:id/links' do
    it 'creates a new Link record with a shortened link' do
      user1 = User.create(email: "user@example.com", password: "user123")
      
      post "/api/v1/users/#{user1.id}/links?link=long-link-example.com"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      link = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(link).to be_a Hash 
      expect(link).to have_key :id
      expect(link[:type]).to eq("link")
      attributes = link[:attributes]
      expect(attributes[:original]).to eq("long-link-example.com")
      expect(attributes[:user_id]).to eq(user1.id)
      expect(attributes[:short]).to be_a String
    end

    describe 'sad path' do
      it "will return 422 if link param is not entered" do
        user1 = User.create(email: "user@example.com", password: "user123")
      
        post "/api/v1/users/#{user1.id}/links"

        expect(response).to_not be_successful
        expect(response.status).to eq(422)

        error = JSON.parse(response.body, symbolize_names: true)[:errors][0]

        expect(error[:status]).to eq("unprocessable_entity")
        expect(error[:message]).to eq("Original can't be blank")
      end

      it "will return 404 if user_id does not exist" do
        post "/api/v1/users/99999999/links?link=this-wont-work.com"

        expect(response).to_not be_successful
        expect(response.status).to eq(422)

        error = JSON.parse(response.body, symbolize_names: true)[:errors][0]

        expect(error[:status]).to eq("unprocessable_entity")
        expect(error[:message]).to eq("User must exist")
      end
    end
  end

  describe 'GET /users/:id/links' do
    it "retrieves the user object with all associated links as attributes" do
      user1 = User.create(email: "user@example.com", password: "user123")
      
      post "/api/v1/users/#{user1.id}/links?link=long-link-example.com"
      post "/api/v1/users/#{user1.id}/links?link=another-long-link.com"

      get "/api/v1/users/#{user1.id}/links"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      user = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(user).to have_key :id
      expect(user[:type]).to eq("user")
      expect(user[:attributes][:email]).to eq("user@example.com")
      links = user[:attributes][:links]
      expect(links.count).to eq(2)
      first_link = links[0]
      expect(first_link).to have_key :id
      expect(first_link[:original]).to eq("long-link-example.com")
      expect(first_link[:short]).to be_a String
      expect(first_link[:user_id]).to eq(user1.id)
    end

    describe "sad path" do
      it "will return 404 if user does not exist" do
        get "/api/v1/users/999999/links"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        error = JSON.parse(response.body, symbolize_names: true)[:errors][0]

        expect(error[:message]).to eq("Record not found")
      end
    end
  end

  describe 'GET /links' do
    it "can return a the json for a link (including full url) when given shortened link" do
      user1 = User.create(email: "user@example.com", password: "user123")
      
      post "/api/v1/users/#{user1.id}/links?link=long-link-example.com"

      link = JSON.parse(response.body, symbolize_names: true)[:data]

      short = link[:attributes][:short]

      get "/api/v1/links?short=#{short}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      link2 = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(link2).to have_key :id
      expect(link2[:type]).to eq("link")
      expect(link2[:attributes][:original]).to eq("long-link-example.com")
      expect(link2[:attributes][:short]).to eq(short)
      expect(link2[:attributes][:user_id]).to eq(user1.id)
    end

    describe "sad path" do
      it "will return a 404 if shortened link doesn't exist" do
        get "/api/v1/links?short=tur.link/12345678"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        error = JSON.parse(response.body, symbolize_names: true)[:errors][0]

        expect(error[:message]).to eq("Record not found")
      end
    end
  end
end