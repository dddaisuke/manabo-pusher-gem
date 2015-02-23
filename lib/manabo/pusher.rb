require "manabo/pusher/version"

module Manabo
  module Pusher
    def bulk_trigger(user_ids, key, value)
      PusherLog.enqueue(user_ids: user_ids, key: key, message: value)
      user_ids.each_slice(100).each do |user_ids|
        Pusher.trigger(user_ids.map(&:to_s), key, value)
      end
    end

    def each_trigger(user_ids)
      pusher_log_params = { user_ids: user_ids }.merge!(yield :for_logging)
      user_ids.each_slice(100).each do |user_ids|
        yield
      end
    end

    def trigger(user_id, key, value)
      Pusher[user_id].trigger(key, value)
    end
  end
end
