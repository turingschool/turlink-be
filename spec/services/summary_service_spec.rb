require 'rails_helper'

RSpec.describe SummaryService do
  it 'gets a summary for a link', :vcr do
    sum_service = SummaryService.new
    sum_service.summarize('www.example.com')

    expect(response).to be_successful
    summary = JSON.parse(response.body, symbolize_names: true)

    expect(summary[:data]).to have_key(:link)
    expect(summary[:data]).to have_key(:summary)

    expect(summary[:data][link]).to eq 'www.example.com'
    expect(summary[:data][:summary]).to eq "1. example 1\n2. example 2\n3. example 3"
  end
end
