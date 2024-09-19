require 'rails_helper'

RSpec.describe 'summary request' do
  xit 'can get a summary of a link', :vcr do
    get '/api/v1/summary?link=www.example.com'

    expect(response).to be_successful

    summary = JSON.parse(response.body, symbolize_names: true)

    expect(summary[:data][:attributes][:link]).to eq('www.example.com')
    expect(summary[:data][:attributes][:summary]).to eq("1. example 1\n2. example 2\n3. example 3")
  end
end
