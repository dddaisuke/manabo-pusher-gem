require "manabo/pusher/version"

module Manabo
  module Pusher
    def bulk_trigger(user_ids, key, message)
      PusherLog.enqueue(user_ids: user_ids, key: key, message: message)
      user_ids.each_slice(100).each do |user_ids|
        Pusher.trigger(user_ids.map(&:to_s), key, message)
      end
    end

    def each_trigger(user_ids, push_messages = [])
      messages = []
      push_messages.each do |push_message|
        message = { user_ids: user_ids }.merge!(push_message)
        PusherLog.enqueue(message)
        messages << message
      end
      user_ids.each_slice(100).each do |user_ids|
        messages.each do |message|
          Pusher.trigger(user_ids.map(&:to_s), message[:key], message[:message])
        end
      end
    end

    def trigger(user_id, key, message)
      Pusher[user_id].trigger(key, message)
    end
  end
end
