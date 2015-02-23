class PusherLogWorker
  include ::Sidekiq::Worker

  sidekiq_options queue: :pusher_log, retry: 10

  class << self
    def enqueue(pusher_log_params)
      Sidekiq.redis do
        begin
          self.perform_async(pusher_log_params)
        rescue => e
          ExceptionNotifier.notify_exception(e,
                                             data: {
                                               env: Rails.env,
                                               worker: self.name.to_s,
                                               sidekiq_options: sidekiq_options_hash,
                                               pusher_log_params: pusher_log_params
                                             },
                                            )
        end
      end
    end
  end

  def perform(pusher_log_params)
    begin
      PusherLog.create(pusher_log_params)
    rescue => e
      ExceptionNotifier.notify_exception(e, data: { env: Rails.env })
    end
  end
end
