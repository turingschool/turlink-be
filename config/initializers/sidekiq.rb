require 'sidekiq'
require 'sidekiq/cron/job'

Sidekiq::Cron::Job.create(
  name: 'Disable inactive links daily',
  cron: '0 0 * * *', # This means daily at midnight
  class: 'DisableInactiveLinksJob'
)