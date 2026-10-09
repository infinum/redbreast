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
        phase.shell_script = <<~SCRIPT
          # Ensure correct Ruby version
          if command -v rbenv &>/dev/null; then
            eval "$(rbenv init -)"
            rbenv install -s
          fi

          # Install Redbreast gem if not present
          if ! gem list -i redbreast > /dev/null; then
            gem install redbreast
          fi

          # Run Redbreast generate only for Debug configurations
          if [[ "${CONFIGURATION}" == *Debug ]]; then
            PATH=$PATH:~/.rbenv/shims
            redbreast generate
          fi
        SCRIPT
      end
    end
  end
end
