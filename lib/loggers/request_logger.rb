require 'active_support/log_subscriber'
require 'active_support/notifications'

module Logger::RequestLogger
  class RequestLogSubscriber < ActiveSupport::LogSubscriber
    def self.setup
      ActiveSupport::Notifications.subscribe('process_action.action_controller') do |name, started, finished, unique_id, payload|
        logger.audit("user_id=#{payload[:user_id]} Processed #{payload[:method]} #{payload[:params].to_json} #{payload[:status]} #{payload[:view_runtime].try(:round, 2)}")
      end
    end
  end
end
