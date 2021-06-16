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
        language = language_prompt
        app_name = app_name_prompt
        bundle_names = bundle_names_prompt(language).split(' ')
        assets_types = assets_types_prompt
        bundles = bundle_names.map do |bundle|
          reference = bundle_reference(bundle, language)
          assets_search_path = assets_search_path_prompt(bundle)
          output_source_path_images = assets_types == 1 ? nil : images_sources_path_prompt(bundle, language)
          output_source_path_colors = assets_types.zero? ? nil : colors_sources_path_prompt(bundle, language)
          include_tests = create_tests_path_prompt?(bundle)
          output_test_path_images = assets_types != 1 && include_tests ? images_tests_path_prompt(bundle, language) : nil
          output_test_path_colors = assets_types != 0 && include_tests ? colors_tests_path_prompt(bundle, language) : nil
          fields = {
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
          language: language,
          bundles: bundles,
          app_name: app_name
        }
        Redbreast::IO::Config.write(config)
        success
      end

      private

      # Language

      def language_prompt
        languages = { 'Swift' => 'swift', 'Objective-C' => 'objc' }
        prompt.select('Choose a language: ', languages)
      end

      # Assets source path

      def assets_search_path_prompt(bundle)
        prompt_text = "Please enter assets folder search paths for bundle #{bundle}?"
        prompt.ask(prompt_text, default: '**/*.xcassets')
      end

      # Bundle names promt

      def bundle_names_prompt(language)
        prompt_text = 'Please enter bundle names that you use separated by spaces'
        case language
        when 'objc'
          prompt.ask(prompt_text, default: 'mainBundle')
        when 'swift'
          prompt.ask(prompt_text, default: 'main')
        end
      end

      def bundle_reference(bundle_name, language)
        case language
        when 'objc'
          "[NSBundle #{bundle_name}]"
        when 'swift'
          ".#{bundle_name}"
        end
      end

      # Images source path

      def images_sources_path_prompt(bundle, language)
        prompt_text = "Where would you like to store images resources files for bundle #{bundle}?"
        case language
        when 'objc'
          prompt.ask(prompt_text, default: './Common/Categories/Images')
        when 'swift'
          prompt.ask(prompt_text, default: './Common/Extensions/UIImageExtension.swift')
        end
      end

      # Colors source path

      def colors_sources_path_prompt(bundle, language)
        prompt_text = "Where would you like to store colors resources files for bundle #{bundle}?"
        case language
        when 'objc'
          prompt.ask(prompt_text, default: './Common/Categories/Colors')
        when 'swift'
          prompt.ask(prompt_text, default: './Common/Extensions/UIColorExtension.swift')
        end
      end

      # Tests

      def create_tests_path_prompt?(bundle)
        prompt.yes?("Would you like to create tests for bundle #{bundle}?")
      end

      def images_tests_path_prompt(bundle, language)
        prompt_text = "Where would you like to store tests for bundle #{bundle}?"
        case language
        when 'objc'
          prompt.ask(prompt_text, default: './Common/Categories/ImagesTest')
        when 'swift'
          prompt.ask(prompt_text, default: './Common/Extensions/UIImageExtensionTest.swift')
        end
      end

      def colors_tests_path_prompt(bundle, language)
        prompt_text = "Where would you like to store tests for bundle #{bundle}?"
        case language
        when 'objc'
          prompt.ask(prompt_text, default: './Common/Categories/ColorsTest')
        when 'swift'
          prompt.ask(prompt_text, default: './Common/Extensions/UIColorExtensionTest.swift')
        end
      end

      def testable_import_prompt(bundle, app_name, language)
        case language
        when 'objc'
          nil
        when 'swift'
          prompt.ask("Please enter a name that will be used for testable import in #{bundle} bundle?", default: "#{app_name}", required: true)
        end
      end

      # Application name propmt

      def app_name_prompt
        prompt.ask('Please enter application name')
      end

      # Assets type prompt

      def assets_types_prompt
        types = { 'Images' => 0, 'Colors' => 1, 'Both' => 2 }
        prompt.select('Choose a type: ', types)
      end
    end
  end
end
