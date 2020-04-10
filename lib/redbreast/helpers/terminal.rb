require 'tty-prompt'

module Redbreast
  module Helper
    # Module used for communicatin with user via terminal
    module Terminal
      def success(message = 'Success!')
        prompt.ok(message)
      end

      def prompt
        @prompt ||= TTY::Prompt.new(interrupt: :exit)
      end
    end
  end
end
