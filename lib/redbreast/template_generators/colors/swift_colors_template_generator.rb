
require_relative '../swift_template_generator'
require 'file_generator'

module Redbreast
    module TemplateGenerator
        module Color
            class Swift < TemplateGenerator::Swift
                include ERB::Util
                def template()
<<-TEMPLATE
import UIKit
<% 
def app_name(app_name)
  "Jaco"
end
%>

//THIS FILE IS AUTOGENERATED, DO NOT EDIT BY HAND
extension UIColor {
    struct <%= app_name("a") %> {}
}

extension UIColor.<%= app_name("a") %> {

<%= generate_file(color_names, "\t", "") %>    
}
TEMPLATE
                end
            end
        end
    end
end