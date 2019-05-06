require 'tty-prompt'

module Redbreast
  module Helper
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