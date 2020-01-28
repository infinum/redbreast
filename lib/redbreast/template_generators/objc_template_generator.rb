module Redbreast
  module TemplateGenerator
    class ObjC
      include ERB::Util

      def h_filename
        fail NotImplementedError, 'Abstract Method'
      end

      def m_filename
        fail NotImplementedError, 'Abstract Method'
      end

      def h_template
        fail NotImplementedError, 'Abstract Method'
      end

      def m_template
        fail NotImplementedError, 'Abstract Method'
      end

    end
  end
end