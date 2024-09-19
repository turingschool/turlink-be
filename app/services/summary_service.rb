class SummaryService

  def get_html(link)
    faraday = Faraday.new(link)
    response = faraday.get
    response.body
  end

  def conn
    Faraday.new("https://api.openai.com/v1/chat/completions") do |faraday|
      faraday.headers[:Authorization] = "Bearer #{Rails.application.credentials.openai[:key]}"
    end
  end

  def summarize(link)
    html_content = get_html(link)
    response = conn.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        model: "gpt-4o-mini",
        messages: [
          {
            role: "system",
            content: "You are a helpful assistant."
          },
          {
            role: "user",
            content: "Summarize the following content: #{html_content}."
          },
          {
            role: "user",
            content: "Use 3 numbered bullet points."
          }
        ]
      }.to_json
    end
    openai_response = response.body
    JSON.parse(response.body, symbolize_names: true)[:choices][0][:message][:content]
  end
end
