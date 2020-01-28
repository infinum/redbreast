require 'redbreast/template_generators/objc_template_generator' # frozen_string_literal: true

module Redbreast
  module TemplateGenerator
    module Test
      # Used for creating color tests in objective-c.
      class ObjC < TemplateGenerator::ObjC
        include ERB::Util
        def h_template
          nil
        end

        def m_template
          <<~TEMPLATE

            #import <XCTest/XCTest.h>
            #import "UIColor+<%= app_name.nil? ? "Common" : app_name %>.h"

            @interface <%= File.basename(bundle[:outputTestPathColors]) %> : XCTestCase

            @end

            @implementation Test

            - (void)testExample
            {
            <%= create_objc_test_cases(asset_names, '[UIColor ', '];')%>
            }

            @end

          TEMPLATE
        end
      end
    end
  end
end
