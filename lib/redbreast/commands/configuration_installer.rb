require 'xcodeproj'

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
        project.build_configurations.each { |conf| puts conf.name if conf.debug? }
        #puts "#{project.build_configurations}"
        #puts "#{project.build_configurations.first.debug?}"
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
        phase.shell_script = "if DEBUG; then\n PATH=$PATH:~/.rbenv/shims\n redbreast generate\nfi"
      end
    end
  end
end
