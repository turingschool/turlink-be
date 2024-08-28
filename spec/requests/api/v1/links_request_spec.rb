require 'rails_helper'

RSpec.describe 'links requests', type: :request do
  describe 'POST /users/:id/links' do
    it 'creates a new Link record with a shortened link' do
      user1 = User.create(email: 'user@example.com', password: 'user123')

      post "/api/v1/users/#{user1.id}/links?link=long-link-example.com"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      link = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(link).to be_a Hash
      expect(link).to have_key :id
      expect(link[:type]).to eq('link')
      attributes = link[:attributes]
      expect(attributes[:original]).to eq('long-link-example.com')
      expect(attributes[:user_id]).to eq(user1.id)
      expect(attributes[:short]).to be_a String
    end

    describe 'sad path' do
      it 'will return 422 if link param is not entered' do
        user1 = User.create(email: 'user@example.com', password: 'user123')

        post "/api/v1/users/#{user1.id}/links"

        expect(response).to_not be_successful
        expect(response.status).to eq(422)

        error = JSON.parse(response.body, symbolize_names: true)[:errors][0]

        expect(error[:status]).to eq('unprocessable_entity')
        expect(error[:message]).to eq("Original can't be blank")
      end

      it 'will return 404 if user_id does not exist' do
        post '/api/v1/users/99999999/links?link=this-wont-work.com'

        expect(response).to_not be_successful
        expect(response.status).to eq(422)

        error = JSON.parse(response.body, symbolize_names: true)[:errors][0]

        expect(error[:status]).to eq('unprocessable_entity')
        expect(error[:message]).to eq('User must exist')
      end
    end
  end

  describe 'GET /users/:id/links' do
    it 'retrieves the user object with all associated links as attributes' do
      user1 = User.create(email: 'user@example.com', password: 'user123')

      post "/api/v1/users/#{user1.id}/links?link=long-link-example.com"
      post "/api/v1/users/#{user1.id}/links?link=another-long-link.com"

      get "/api/v1/users/#{user1.id}/links"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      user = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(user).to have_key :id
      expect(user[:type]).to eq('user')
      expect(user[:attributes][:email]).to eq('user@example.com')
      links = user[:attributes][:links]
      expect(links.count).to eq(2)
      first_link = links[0]
      expect(first_link).to have_key :id
      expect(first_link[:original]).to eq('long-link-example.com')
      expect(first_link[:short]).to be_a String
      expect(first_link[:user_id]).to eq(user1.id)
    end

    describe 'sad path' do
      it 'will return 404 if user does not exist' do
        get '/api/v1/users/999999/links'

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        error = JSON.parse(response.body, symbolize_names: true)[:errors][0]

        expect(error[:message]).to eq('Record not found')
      end
    end
  end

  describe 'GET /links' do
    it 'can return a the json for a link (including full url) when given shortened link' do
      user1 = User.create(email: 'user@example.com', password: 'user123')

      post "/api/v1/users/#{user1.id}/links?link=long-link-example.com"

      link = JSON.parse(response.body, symbolize_names: true)[:data]

      short = link[:attributes][:short]

      get "/api/v1/links?short=#{short}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      link2 = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(link2).to have_key :id
      expect(link2[:type]).to eq('link')
      expect(link2[:attributes][:original]).to eq('long-link-example.com')
      expect(link2[:attributes][:short]).to eq(short)
      expect(link2[:attributes][:user_id]).to eq(user1.id)
    end

    it 'returns a link with click_count and last_click attributes' do
      user1 = User.create(email: 'user@example.com', password: 'user123')

      post "/api/v1/users/#{user1.id}/links?link=long-link-example.com"

      link = JSON.parse(response.body, symbolize_names: true)[:data]
      short = link[:attributes][:short]

      get "/api/v1/links?short=#{short}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      link2 = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(link2[:attributes]).to have_key :click_count
      expect(link2[:attributes]).to have_key :last_click
      expect(link2[:attributes][:click_count]).to eq(1)
      expect(link2[:attributes][:last_click]).to be_present
    end

    it 'can update click count multiple times' do
      user1 = User.create(email: 'user@example.com', password: 'user123')

      post "/api/v1/users/#{user1.id}/links?link=long-link-example.com"

      link = JSON.parse(response.body, symbolize_names: true)[:data]
      short = link[:attributes][:short]

      get "/api/v1/links?short=#{short}"
      get "/api/v1/links?short=#{short}"
      get "/api/v1/links?short=#{short}"

      link2 = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(link2[:attributes][:click_count]).to eq(3)
    end

    it 'maintains separate click counts for different links' do
      user1 = User.create(email: 'user@example.com', password: 'user123')

      post "/api/v1/users/#{user1.id}/links?link=first-link.com"
      first_link = JSON.parse(response.body, symbolize_names: true)[:data]
      first_short = first_link[:attributes][:short]

      post "/api/v1/users/#{user1.id}/links?link=second-link.com"
      second_link = JSON.parse(response.body, symbolize_names: true)[:data]
      second_short = second_link[:attributes][:short]

      get "/api/v1/links?short=#{first_short}"
      get "/api/v1/links?short=#{first_short}"
      get "/api/v1/links?short=#{second_short}"

      get "/api/v1/links?short=#{first_short}"
      first_link_response = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(first_link_response[:attributes][:click_count]).to eq(3)

      get "/api/v1/links?short=#{second_short}"
      second_link_response = JSON.parse(response.body, symbolize_names: true)[:data]
      expect(second_link_response[:attributes][:click_count]).to eq(2)
    end

    describe 'sad path' do
      it "will return a 404 if shortened link doesn't exist" do
        get '/api/v1/links?short=tur.link/12345678'

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        error = JSON.parse(response.body, symbolize_names: true)[:errors][0]

        expect(error[:message]).to eq('Record not found')
      end
    end
  end

  describe 'GET /api/v1/top_links' do
    before do
      @user = User.create(email: 'user@example.com', password: 'password')
      @tag1 = Tag.create(name: 'javascript')
      @tag2 = Tag.create(name: 'ruby')

      @link1 = Link.create(original: 'https://example1.com', short: 'tur.link/abc123', user: @user, click_count: 100)
      @link2 = Link.create(original: 'https://example2.com', short: 'tur.link/def456', user: @user, click_count: 75)
      @link3 = Link.create(original: 'https://example3.com', short: 'tur.link/ghi789', user: @user, click_count: 50)
      @link4 = Link.create(original: 'https://example4.com', short: 'tur.link/jkl012', user: @user, click_count: 25)
      @link5 = Link.create(original: 'https://example5.com', short: 'tur.link/mno345', user: @user, click_count: 10)
      @link6 = Link.create(original: 'https://example6.com', short: 'tur.link/pqr678', user: @user, click_count: 5)

      @link1.tags << @tag1
      @link2.tags << @tag2
      @link3.tags << @tag1
    end

    it 'can return the top 5 links by click count' do
      get '/api/v1/top_links'

      expect(response).to be_successful
      links = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(links.count).to eq(5)
      expect(links[0][:attributes][:click_count]).to eq(100)
      expect(links.last[:attributes][:click_count]).to eq(10)
    end

    it 'can return the top 5 links by click count for a specific tag' do
      get '/api/v1/top_links?tag=javascript'

      expect(response).to be_successful
      links = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(links.count).to eq(2)
      expect(links[0][:attributes][:click_count]).to eq(100)
      expect(links.last[:attributes][:click_count]).to eq(50)
    end
  end
end
