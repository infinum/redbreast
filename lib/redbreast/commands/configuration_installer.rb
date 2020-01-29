require 'xcodeproj' # frozen_string_literal: true

module Redbreast
  module Command
    # Class for installing configuration
    class ConfigurationInstaller
      include Helper::Terminal
      include Helper::General
      def self.init
        new.call
      end

      def call
        prompt.say('Adding generation script to xcode buid phases...')
        project = fetch_project
        configure_target project.targets.first
        project.save
        success('Build phase setup!')
      end

      private

      def fetch_project
        path = Dir.glob('*.xcodeproj').first
        raise '.xcodeproj file not found' if path.nil?

        Xcodeproj::Project.open(path)
      end

      def configure_target(target)
        puts target.build_phases.class
        phase = target.new_shell_script_build_phase('Redbreast generate')
        phase.shell_script = "PATH=$PATH:~/.rbenv/shims\nredbreast generate"
      end
    end
  end
end
