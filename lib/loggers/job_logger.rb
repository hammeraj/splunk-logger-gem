require 'active_support/notifications'

module Logger::JobLogger
  def self.setup
    ActiveSupport::Notifications.subscribe "perform.backburner" do |name, started, finished, unique_id, data|
      Rails.logger.audit("resource=#{data[:resource].to_json}")
    end
  end
end
