require_relative '../swiftui_template_generator' 

module Redbreast
  module TemplateGenerator
    module Image
      # Used for creating images in swift.
      class SwiftUI < TemplateGenerator::SwiftUI
        include ERB::Util

        def template
          <<~TEMPLATE
            import SwiftUI

            // THIS FILE IS AUTOGENERATED, DO NOT EDIT BY HAND
            // swiftlint:disable file_length type_body_length line_length superfluous_disable_commandextension_access_modifier
            <%= generate_extension('Image', app_name) %>
            <%= generate_file_swift(names: asset_names, variable: 'public static var %s: Image { Image("%s", bundle: %s) }', bundle: bundle) %>
            }
          TEMPLATE
        end
      end
    end
  end
end
