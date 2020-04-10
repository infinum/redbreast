require_relative '../swift_template_generator' 

module Redbreast
  module TemplateGenerator
    module Image
      # Used for creating images in swift.
      class Swift < TemplateGenerator::Swift
        include ERB::Util

        def template
          <<~TEMPLATE
            import UIKit

            //THIS FILE IS AUTOGENERATED, DO NOT EDIT BY HAND
            <%= generate_extension('UIImage', app_name) %>
            <%= generate_file_swift(names: asset_names, variable: 'static var %s: UIImage { return UIImage(named: "%s", in: %s, compatibleWith: nil)! }', bundle: bundle) %>
            }
          TEMPLATE
        end
      end
    end
  end
end