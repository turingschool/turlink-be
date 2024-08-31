class SummaryService
  def conn
    Faraday.new('https://nameless-garden-14218-de5663d17d61.herokuapp.com/')
  end

  def summarize
    conn.get('/api/v1/ping/')
  end
end
