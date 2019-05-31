
module Redbreast
    module Helper
        module Hash
            def compact
            delete_if { |k, v| v.nil? }
            end
        end
    end
end