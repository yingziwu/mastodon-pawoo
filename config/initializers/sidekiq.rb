# frozen_string_literal: true

require 'sidekiq/worker_killer'

namespace    = ENV.fetch('REDIS_NAMESPACE') { nil }
redis_params = { url: ENV['REDIS_URL'] }

if namespace
  redis_params[:namespace] = namespace
end

Sidekiq.configure_server do |config|
  config.redis = redis_params

  config.server_middleware do |chain|
    chain.add SidekiqErrorHandler
  end

  config.server_middleware do |chain|
    chain.add Sidekiq::WorkerKiller, max_rss: (ENV['PAWOO_SIDEKIQ_MAX_RSS'] || 750).to_i, grace_time: 60
  end
end

Sidekiq.configure_client do |config|
  config.redis = redis_params
end

Sidekiq::Logging.logger.level = ::Logger.const_get(ENV.fetch('RAILS_LOG_LEVEL', 'info').upcase.to_s)
