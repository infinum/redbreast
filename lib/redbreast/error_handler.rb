module Redbreast
  class ErrorHandler
    extend Helper::Terminal

    class << self
      def rescuable
        yield
      rescue => e
        handle(e)
      end

      def handle(e)
        prompt.error(
          case e
          when Errno::ENOENT
            "We could not find a file that we need:\n\n#{e.message}"
          else
            "An error happened. This might help:\n\n#{e.message}"
          end
        )
      end
    end
  end
end