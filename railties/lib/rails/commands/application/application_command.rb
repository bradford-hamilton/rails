# frozen_string_literal: true

require_relative "../../generators"
require_relative "../../generators/quails/app/app_generator"

module Quails
  module Generators
    class AppGenerator # :nodoc:
      # We want to exit on failure to be kind to other libraries
      # This is only when accessing via CLI
      def self.exit_on_failure?
        true
      end
    end
  end

  module Command
    class ApplicationCommand < Base # :nodoc:
      hide_command!

      def help
        perform # Punt help output to the generator.
      end

      def perform(*args)
        Quails::Generators::AppGenerator.start \
          Quails::Generators::ARGVScrubber.new(args).prepare!
      end
    end
  end
end
