class DisableInactiveLinksJob
  include Sidekiq::Worker
  queue_as :default

  def perform
    links = Link.all
    six_months_ago = Time.current - 15552000 #this is 180 days in seconds
    links.each do |link|
      if link.click_count < 50 && link.last_click != nil && link.last_click < six_months_ago
        link.update(disabled: true)
      end
    end
  end
end
