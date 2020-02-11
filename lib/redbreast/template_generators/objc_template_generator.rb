# frozen_string_literal: true

module Redbreast
  module TemplateGenerator
    # Class for creating ObjC templates
    class ObjC
      include ERB::Util
      def h_filename
        raise NotImplementedError, 'Abstract Method'
      end

      def m_filename
        raise NotImplementedError, 'Abstract Method'
      end

      def h_template
        raise NotImplementedError, 'Abstract Method'
      end

      def m_template
        raise NotImplementedError, 'Abstract Method'
      end
    end
  end
end
