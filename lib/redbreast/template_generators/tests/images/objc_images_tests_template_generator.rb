require 'redbreast/template_generators/objc_template_generator'

module Redbreast
  module TemplateGenerator
    module ImageTest
      # Used for creating image tests in objective-c.
      class ObjC < TemplateGenerator::ObjC
        include ERB::Util
        def h_template
          nil
        end

        def m_template
          <<~TEMPLATE

            #import <XCTest/XCTest.h>
            #import "UIImage+<%= app_name.nil? ? "Common" : app_name %>.h"

            @interface <%= File.basename(bundle[:outputTestPathImages]) %> : XCTestCase

            @end

            @implementation Test

            - (void)testExample
            {
            <%= create_objc_test_cases(names: asset_names, variable_declaration: '[UIImage ', variable_end: '];')%>
            }

            @end
          TEMPLATE
        end
      end
    end
  end
end

