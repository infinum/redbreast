require_relative '../swift_template_generator' 

module Redbreast
  module TemplateGenerator
    module Color
      # Used for creating colors in swift.
      class Swift < TemplateGenerator::Swift
        include ERB::Util
        def template
          <<~TEMPLATE
            import UIKit

            // THIS FILE IS AUTOGENERATED, DO NOT EDIT BY HAND
            // swiftlint:disable file_length type_body_length line_length superfluous_disable_command
            <%= generate_extension('UIColor', app_name) %>
            <%= generate_file_swift(names: asset_names, variable: 'public static var %s: UIColor { return UIColor(named: "%s", in: %s, compatibleWith: nil)! }', bundle: bundle) %>
            }
          TEMPLATE
        end
      end
    end
  end
end
