module Redbreast
  module Command
    # Class for creating color tests
    class ColorTestGenerator
      include Helper::Terminal
      include Helper::General

      def self.init
        new.call
      end

      def call
        filtered_bundles = bundles.select { |bundle| bundle[:outputTestPathColors] }
        return if filtered_bundles.empty?

        prompt.say('Generating color test resources...')
        generate_test_sources(bundles, app_name)
        success('Color test resources generated!')
      end

      private

      def generate_test_sources(bundles, app_name)
        bundles.each do |bundle|
          color_names = pull_asset_names(bundle[:assetsSearchPath])
          bundle_language = bundle[:language] || programming_language
          write_tests(color_names, bundle, bundle_language, app_name)
        end
      end

      # Serializing data

      def write_tests(color_names, bundle, programming_language, app_name)
        output_path = bundle[:outputTestPathColors]

        return if output_path.to_s.empty?

        case programming_language.downcase
        when 'objc'
          serializer = Redbreast::Serializer::ObjC
          template_generator = Redbreast::TemplateGenerator::ColorTest::ObjC
        when 'swift'
          serializer = Redbreast::Serializer::Swift
          template_generator = Redbreast::TemplateGenerator::ColorTest::Swift
        when 'swiftui'
          serializer = Redbreast::Serializer::SwiftUI
          template_generator = Redbreast::TemplateGenerator::ColorTest::SwiftUI
        end
        serializer.new(color_names, bundle, app_name).save(output_source_path: output_path, template_generator: template_generator.new, generate_colors: true)

      end

      # Pulling data

      def pull_asset_names(assetsSearchPath)
        Redbreast::Crawler::Color
          .color_names_uniq(assetsSearchPath)
      end
    end
  end
end
