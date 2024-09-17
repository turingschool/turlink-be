require 'rails_helper'

RSpec.describe 'tags requests', type: :request do
  describe 'GET /tags' do
    before(:each) do
      Tag.create(name: "javascript")
      Tag.create(name: "react")
      Tag.create(name: "ruby")
      Tag.create(name: "rails")
      Tag.create(name: "video")
      Tag.create(name: "blog")
      Tag.create(name: "tutorial")
      Tag.create(name: "python")
      Tag.create(name: "java")
      Tag.create(name: "C#")
    end
    it 'gets all tags from database' do
      get "/api/v1/tags"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      tags = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(tags).to be_a Array
      expect(tags.count).to eq(10)

      first_tag = tags[0]
      expect(first_tag).to be_a Hash
      expect(first_tag).to have_key :id
      expect(first_tag[:type]).to eq("tag")
      expect(first_tag[:attributes][:name]).to be_a String
    end
  end

  describe 'POST /tags' do
    before(:each) do
      @tag1 = Tag.create(name: "javascript")
      Tag.create(name: "react")
      Tag.create(name: "ruby")
      Tag.create(name: "rails")
      Tag.create(name: "video")
      Tag.create(name: "blog")
      Tag.create(name: "tutorial")
      Tag.create(name: "python")
      Tag.create(name: "java")
      Tag.create(name: "C#")
    end
    it 'adds a tag to a link' do
      user1 = User.create(email: "user@example.com", password: "user123")
      post "/api/v1/users/#{user1.id}/links?link=long-link-example.com"

      post "/api/v1/tags?link=#{Link.last.id}&tag=#{@tag1.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      link = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(link).to be_a Hash
      expect(link).to have_key :id
      expect(link[:type]).to eq("link")

      attrs = link[:attributes]
      expect(attrs[:original]).to eq("long-link-example.com")
      expect(attrs[:short]).to be_a String
      expect(attrs[:user_id]).to eq(user1.id)

      tags = attrs[:tags]
      expect(tags).to be_a Array
      first_tag = tags[0]
      expect(first_tag).to be_a Hash
      expect(first_tag).to have_key :id
      expect(first_tag[:name]).to eq("javascript")
    end

    it 'can create a new tag and add it to a link' do
      user1 = User.create(email: "user@example.com", password: "user123")
      post "/api/v1/users/#{user1.id}/links?link=long-link-example.com"

      post "/api/v1/tags?link=#{Link.last.id}&newTag=new tech topic"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      link = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(link).to be_a Hash
      expect(link).to have_key :id
      expect(link[:type]).to eq("link")

      attrs = link[:attributes]
      expect(attrs[:original]).to eq("long-link-example.com")
      expect(attrs[:short]).to be_a String
      expect(attrs[:user_id]).to eq(user1.id)

      tags = attrs[:tags]
      expect(tags).to be_a Array
      first_tag = tags[0]
      expect(first_tag).to be_a Hash
      expect(first_tag).to have_key :id
      expect(first_tag[:name]).to eq("new tech topic")
    end

    describe "sad path" do
      it "returns 404 when link or tag isn't passed or doesn't exist" do
        user1 = User.create(email: "user@example.com", password: "user123")
        post "/api/v1/users/#{user1.id}/links?link=long-link-example.com"

        post "/api/v1/tags?link=#{Link.last.id}"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        error = JSON.parse(response.body, symbolize_names: true)[:errors][0]

        expect(error[:message]).to eq("Link or Tag not found")
      end
    end
  end

  describe 'DELETE /tags/:id' do
    before(:each) do
      @tag1 = Tag.create(name: "javascript")
      Tag.create(name: "react")
      Tag.create(name: "ruby")
      Tag.create(name: "rails")
      Tag.create(name: "video")
      Tag.create(name: "blog")
      Tag.create(name: "tutorial")
      Tag.create(name: "python")
      Tag.create(name: "java")
      Tag.create(name: "C#")
    end
    it "removes a tag from a link" do
      user1 = User.create(email: "user@example.com", password: "user123")
      post "/api/v1/users/#{user1.id}/links?link=long-link-example.com"

      post "/api/v1/tags?link=#{Link.last.id}&tag=#{@tag1.id}"

      expect(response).to be_successful
      expect(response.status).to eq(200)

      delete "/api/v1/tags/#{@tag1.id}?link=#{Link.last.id}"

      link = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(link).to be_a Hash 
      expect(link[:id]).to eq(Link.last.id.to_s)
      expect(link[:type]).to eq("link")

      tags = link[:attributes][:tags]
      expect(tags).to be_a Array
      expect(tags).to eq([])
    end
  end

  describe 'GET /tags?link=link_id' do
    before(:each) do
      @tag1 = Tag.create(name: "javascript")
      @tag2 = Tag.create(name: "react")
      Tag.create(name: "ruby")
      Tag.create(name: "rails")
      Tag.create(name: "video")
      Tag.create(name: "blog")
      Tag.create(name: "tutorial")
      Tag.create(name: "python")
      Tag.create(name: "java")
      Tag.create(name: "C#")
    end
    it "can get all tags for a given link" do
      user1 = User.create(email: "user@example.com", password: "user123")
      post "/api/v1/users/#{user1.id}/links?link=long-link-example.com"
      post "/api/v1/tags?link=#{Link.last.id}&tag=#{@tag1.id}"
      post "/api/v1/tags?link=#{Link.last.id}&tag=#{@tag2.id}"

      get "/api/v1/tags?link=#{Link.last.id}"

      link = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(link).to be_a Hash 
      expect(link[:id]).to eq(Link.last.id.to_s)
      expect(link[:type]).to eq("link")

      tags = link[:attributes][:tags]
      expect(tags).to be_a Array
      expect(tags.count).to eq(2)
      first_tag = tags[0]
      expect(first_tag).to be_a Hash
      expect(first_tag).to have_key :id
      expect(first_tag[:name]).to eq("javascript")
    end
  end
end