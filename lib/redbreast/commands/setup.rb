require 'commander/blank'
require 'commander/command'

module Redbreast
  module Command
    # Class for setting up the program
    class Setup
      include Helper::Terminal
      include Helper::General
      include Helper::HashHelper

      def self.init(options = Commander::Command::Options.new)
        new(options).call
      end

      def initialize(options = Commander::Command::Options.new)
        @options = options
      end

      def call
        app_name = app_name_prompt
        bundle_names = bundle_names_prompt().split(' ')
        bundles = bundle_names.map do |bundle|
          language = language_prompt(bundle)
          assets_types = assets_types_prompt(bundle)
          reference = bundle_reference(bundle, language)
          assets_search_path = assets_search_path_prompt(bundle)
          output_source_path_images = assets_types == 1 ? nil : images_sources_path_prompt(bundle, language)
          output_source_path_colors = assets_types.zero? ? nil : colors_sources_path_prompt(bundle, language)
          include_tests = create_tests_path_prompt?(bundle)
          output_test_path_images = assets_types != 1 && include_tests ? images_tests_path_prompt(bundle, language) : nil
          output_test_path_colors = assets_types != 0 && include_tests ? colors_tests_path_prompt(bundle, language) : nil
          fields = {
            language: language,
            name: bundle,
            reference: reference,
            assetsSearchPath: assets_search_path,
            outputSourcePathImages: output_source_path_images,
            outputSourcePathColors: output_source_path_colors,
            outputTestPathImages: output_test_path_images,
            outputTestPathColors: output_test_path_colors,
            testableImport: include_tests ? testable_import_prompt(bundle, app_name, language) : nil
          }
          compact fields
        end
        config = {
          bundles: bundles,
          app_name: app_name
        }
        Redbreast::IO::Config.write(config)
        success
      end

      private

      # Language

      def language_prompt(bundle)
        languages = { 'Swift' => 'swift', 'SwiftUI' => 'swiftui', 'Objective-C' => 'objc', }
        prompt.select("Choose a language for bundle #{bundle}: ", languages)
      end

      # Assets source path

      def assets_search_path_prompt(bundle)
        prompt_text = "Please enter assets folder search paths for bundle #{bundle}?"
        prompt.ask(prompt_text, default: '**/*.xcassets')
      end

      # Bundle names promt

      def bundle_names_prompt()
        prompt_text = 'Please enter bundle names that you use separated by spaces. For Obj-C use mainBundle.'
        prompt.ask(prompt_text, default: 'main')
      end

      def bundle_reference(bundle_name, language)
        case language
        when 'objc'
          "[NSBundle #{bundle_name}]"
        when 'swift'
          ".#{bundle_name}"
        when 'swiftui'
          ".#{bundle_name}"
        end
      end

      # Images source path

      def images_sources_path_prompt(bundle, language)
        prompt_text = "Where would you like to store image resources files for bundle #{bundle}?"
        case language
        when 'objc'
          prompt.ask(prompt_text, default: './Common/Categories/Images')
        when 'swift'
          prompt.ask(prompt_text, default: './Common/Extensions/UIImageExtension.swift')
        when 'swiftui'
          prompt.ask(prompt_text, default: './Common/Extensions/ImageExtension.swift')
        end
      end

      # Colors source path

      def colors_sources_path_prompt(bundle, language)
        prompt_text = "Where would you like to store color resources files for bundle #{bundle}?"
        case language
        when 'objc'
          prompt.ask(prompt_text, default: './Common/Categories/Colors')
        when 'swift'
          prompt.ask(prompt_text, default: './Common/Extensions/UIColorExtension.swift')
        when 'swiftui'
          prompt.ask(prompt_text, default: './Common/Extensions/ColorExtension.swift')
        end
      end

      # Tests

      def create_tests_path_prompt?(bundle)
        prompt.yes?("Would you like to create tests for bundle #{bundle}?")
      end

      def images_tests_path_prompt(bundle, language)
        prompt_text = "Where would you like to store image tests for bundle #{bundle}?"
        case language
        when 'objc'
          prompt.ask(prompt_text, default: './Common/Categories/ImagesTest')
        when 'swift'
          prompt.ask(prompt_text, default: './Common/Extensions/UIImageExtensionTest.swift')
        when 'swiftui'
          prompt.ask(prompt_text, default: './Common/Extensions/ImageExtensionTest.swift')
        end
      end

      def colors_tests_path_prompt(bundle, language)
        prompt_text = "Where would you like to store color tests for bundle #{bundle}?"
        case language
        when 'objc'
          prompt.ask(prompt_text, default: './Common/Categories/ColorsTest')
        when 'swift'
          prompt.ask(prompt_text, default: './Common/Extensions/UIColorExtensionTest.swift')
        when 'swiftui'
          prompt.ask(prompt_text, default: './Common/Extensions/ColorExtensionTest.swift')
        end
      end

      def testable_import_prompt(bundle, app_name, language)
        case language
        when 'objc'
          nil
        when 'swift'
          prompt.ask("Please enter a name that will be used for testable import in #{bundle} bundle?", default: "#{app_name}", required: true)
        when 'swiftui'
          prompt.ask("Please enter a name that will be used for testable import in #{bundle} bundle?", default: "#{app_name}", required: true)
        end
      end

      # Application name propmt

      def app_name_prompt
        prompt.ask('Please enter application name')
      end

      # Assets type prompt

      def assets_types_prompt(bundle)
        types = { 'Images' => 0, 'Colors' => 1, 'Both' => 2 }
        prompt.select("Choose a type for bundle #{bundle}: ", types)
      end
    end
  end
end
