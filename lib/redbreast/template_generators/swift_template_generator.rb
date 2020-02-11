# frozen_string_literal: true

module Redbreast
  module TemplateGenerator
    # Class for creating Swift templates
    class Swift
      include ERB::Util
      def template
        raise NotImplementedError, 'Abstract Method'
      end
    end
  end
end
