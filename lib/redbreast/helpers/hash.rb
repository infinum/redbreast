module Redbreast
  module Helper
    # Module used for creating compact dictionaries
    module HashHelper
      def compact(dictionary)
        dictionary.delete_if { |_k, v| v.nil? }
      end
    end
  end
end
