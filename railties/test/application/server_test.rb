# frozen_string_literal: true

require "isolation/abstract_unit"
require "console_helpers"
require "quails/command"
require "quails/commands/server/server_command"

module ApplicationTests
  class ServerTest < ActiveSupport::TestCase
    include ActiveSupport::Testing::Isolation
    include ConsoleHelpers

    def setup
      build_app
    end

    def teardown
      teardown_app
    end

    test "deprecate support of older `config.ru`" do
      remove_file "config.ru"
      app_file "config.ru", <<-RUBY
        require_relative 'config/environment'
        run AppTemplate::Application
      RUBY

      server = Quails::Server.new(config: "#{app_path}/config.ru")
      server.app

      log = File.read(Quails.application.config.paths["log"].first)
      assert_match(/DEPRECATION WARNING: Use `Quails::Application` subclass to start the server is deprecated/, log)
    end

    test "restart quails server with custom pid file path" do
      skip "PTY unavailable" unless available_pty?

      master, slave = PTY.open
      pid = nil

      begin
        pid = Process.spawn("#{app_path}/bin/quails server -P tmp/dummy.pid", in: slave, out: slave, err: slave)
        assert_output("Listening", master)

        Dir.chdir(app_path) { system("bin/quails restart") }

        assert_output("Restarting", master)
        assert_output("Inherited", master)
      ensure
        kill(pid) if pid
      end
    end

    private
      def kill(pid)
        Process.kill("TERM", pid)
        Process.wait(pid)
      rescue Errno::ESRCH
      end
  end
end
