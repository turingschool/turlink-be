class SummarySerializer
  def initialize(summary)
    @link = summary[:data][:link]
    @summary = summary[:data][:summary]
  end

  def serialize_json
    {
      data: {
        attributes: {
          link: @link,
          summary: @summary
        }
      }
    }
  end
end
