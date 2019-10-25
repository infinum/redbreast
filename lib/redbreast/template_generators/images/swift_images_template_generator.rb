require_relative '../swift_template_generator'

module Redbreast
    module TemplateGenerator
        module Image
            class Swift < TemplateGenerator::Swift
                include ERB::Util

                def template()
<<-TEMPLATE

import UIKit

//THIS FILE IS AUTOGENERATED, DO NOT EDIT BY HAND
extension UIImage {

    <%- image_names.each do |name| -%>
    static var <%= clean_variable_name(name) %>: UIImage { return UIImage(named: "<%= name %>", in: <%= bundle[:reference] %>, compatibleWith: nil)! }
    <%- end -%>

}

TEMPLATE
                end
            end
        end
    end
end