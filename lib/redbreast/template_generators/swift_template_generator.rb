module Redbreast
  module TemplateGenerator
    class Swift
      include ERB::Util

      def template
        fail NotImplementedError, 'Abstract Method'
      end

    end
  end
end