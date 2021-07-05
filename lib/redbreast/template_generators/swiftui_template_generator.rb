module Redbreast
  module TemplateGenerator
    # Class for creating SwiftUI templates
    class SwiftUI
      include ERB::Util
      def template
        raise NotImplementedError, 'Abstract Method'
      end
    end
  end
end
