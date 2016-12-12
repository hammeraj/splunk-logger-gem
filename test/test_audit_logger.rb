require 'minitest/autorun'
require 'active_support/logger'
require 'rails'

require_relative '../lib/audit_logger'

describe AuditLogger do
  class Dir
    def self.[](args)
      [File.expand_path('../../lib/loggers/foo.rb', __FILE__)]
    end
  end

  class Logger::Foo
    def self.setup
      "Called setup!!!"
    end
  end

  def self.prepare
    Dir.mkdir('/tmp/log')
    File.write('/tmp/log/test.log', '')
    File.write(File.expand_path('../../lib/loggers/foo.rb', __FILE__), '')

    def Rails.root
      Pathname.new('/tmp')
    end

    def Rails.env
      "test"
    end
  end

  MiniTest::Unit.after_tests do
    File.delete('/tmp/log/test.log')
    Dir.rmdir('/tmp/log')
    File.delete(File.expand_path('../../lib/loggers/foo.rb', __FILE__))
  end

  prepare

  describe "#initialize" do

    it "should set the formatter" do
      logger = AuditLogger.new
      refute_nil logger.formatter
    end

    it "should call setup" do
      logger = Minitest::Mock.new
      logger.expect(:call, 'Called setup!!!')
      Logger::Foo.stub(:setup, logger) do
        AuditLogger.new
      end
      logger.verify
    end
  end

  describe "#audit?" do
    it "should be true" do
      assert_equal AuditLogger.new.audit?, true
    end
  end

  describe "#audit" do
    it "should add the message" do
      assert_equal AuditLogger.new.audit("TEST"), true
    end
  end

  describe "#format_severity" do
    it "should return AUDIT when severity is 6" do
      assert_equal AuditLogger.new.format_severity(6), "AUDIT"
    end
  end
end
