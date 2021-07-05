require 'redbreast/template_generators/swiftui_template_generator'

module Redbreast
  module TemplateGenerator
    module ColorTest
      # Used for creating color tests in swift.
      class Swift < TemplateGenerator::SwiftUI
        include ERB::Util
        def template
<<~TEMPLATE
  import SwiftUI
  import XCTest
  @testable import <%= bundle[:testableImport] %>

  // THIS FILE IS AUTOGENERATED, DO NOT EDIT BY HAND
  class <%= File.basename(bundle[:outputTestPathColors], ".*") %>: XCTestCase {

      func testIfColorsArePresent() {
  <%= create_swift_test_cases(names: asset_names, declaration: '_ = Color.', app_name: app_name) %>
      }
  }
TEMPLATE
        end
      end
    end
  end
end