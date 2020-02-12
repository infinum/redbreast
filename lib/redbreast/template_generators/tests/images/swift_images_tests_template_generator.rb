require 'redbreast/template_generators/swift_template_generator' # frozen_string_literal: true

module Redbreast
  module TemplateGenerator
    module ImageTest
      # Used for creating image tests in swift.
      class Swift < TemplateGenerator::Swift
        include ERB::Util
        def template
<<~TEMPLATE
  import UIKit
  import XCTest
  @testable import <%= bundle[:testableImport] %>

  //THIS FILE IS AUTOGENERATED, DO NOT EDIT BY HAND
  class <%= File.basename(bundle[:outputTestPathImages], ".*") %>: XCTestCase {

      func testIfImagesArePresent() {
    <%= create_swift_test_cases(asset_names, '_ = UIImage.', app_name) %>
      }
  }
TEMPLATE
        end
      end
    end
  end
end
