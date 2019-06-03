module Redbreast
    module Helper
        module HashHelper
            def compact(dictionary)
                dictionary.delete_if { |k, v| v.nil? }
            end
        end
    end
end