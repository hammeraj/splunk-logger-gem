class AuditLogger < ActiveSupport::Logger
  AUDIT = 6
  SEV_LABEL << 'AUDIT'

  def initialize
    super(Rails.root.join('log', Rails.env + '.log'))
    self.formatter = proc { |severity, datetime, progname, message|
      unless message.blank?
        "#{datetime} application=data_view, rails_env=#{Rails.env}, severity=#{severity}, message=\"#{message.try(:strip)}\"\n"
      end
    }

    Dir[Rails.root.join("lib", "loggers", "*.rb")].each { |logger|
      require logger
      klass = Logger.const_get(File.basename(logger, ".rb").classify)
      if klass.respond_to?(:setup)
        klass.setup
      else
        klass.const_get(klass.constants.first).setup
      end
    }
  end

  def audit?
    true
  end

  def audit(message)
    add(AUDIT, message)
  end

  def format_severity(severity)
    SEV_LABEL[severity] || 'ANY'
  end
end
