# frozen_string_literal: true

module Redbreast
  # Class for handling errors that occurr
  class ErrorHandler
    extend Helper::Terminal

    class << self
      def rescuable
        yield
      rescue StandardError => e
        handle(e)
      end

      def handle(error)
        prompt.error(
          case error
          when Errno::ENOENT
            "We could not find a file that we need:\n\n#{error.message}"
          else
            "An error happened. This might help:\n\n#{error.message}"
          end
        )
      end
    end
  end
end
