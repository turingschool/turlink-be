class SummaryService
  def conn
    Faraday.new(
      url: 'https://nameless-garden-14218-de5663d17d61.herokuapp.com/',
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  def summarize(resource)
    response = conn.post('api/v1/ping') do |req|
      req.body = { link: resource }.to_json
    end

    JSON.parse(response.body, symbolize_names: true)
  end
end
