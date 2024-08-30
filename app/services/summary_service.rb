class SummaryService
  def conn
    Faraday.new(
      url: 'https://nameless-garden-14218-de5663d17d61.herokuapp.com/',
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  def summarize
    conn.post('api/v1/ping') do |req|
      req.body = { link: 'wwww.example.com' }.to_json
    end
  end
end
