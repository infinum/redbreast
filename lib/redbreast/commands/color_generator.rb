module Redbreast
  module Command
    # Class for generating color files
    class ColorGenerator
      include Helper::Terminal
      include Helper::General

      def self.init
        new.call
      end

      def call
        filtered_bundles = bundles.select { |bundle| bundle[:outputSourcePathColors] }
        return if filtered_bundles.empty?

        prompt.say('Generating color resources...')
        generate_color_sources(filtered_bundles, app_name)
        success('Color resources generated!')
      end

      private

      def generate_color_sources(bundles, app_name)
        bundles.each do |bundle|
          color_names = pull_asset_names(bundle[:assetsSearchPath])
          bundle_language = bundle[:language] || programming_language 
          shouldOmitNamespace = bundle[:shouldOmitNamespace]
          namespace = shouldOmitNamespace ? '' : app_name
          write_colors(color_names, bundle, bundle_language, namespace)
        end
      end

      # Serializing data

      def write_colors(color_names, bundle, programming_language, app_name)
        output_path = bundle[:outputSourcePathColors]
        return if output_path.to_s.empty?

        case programming_language.downcase
        when 'objc'
          serializer = Redbreast::Serializer::ObjC
          template_generator = Redbreast::TemplateGenerator::Color::ObjC
        when 'swift'
          serializer = Redbreast::Serializer::Swift
          template_generator = Redbreast::TemplateGenerator::Color::Swift
        when 'swiftui'
          serializer = Redbreast::Serializer::SwiftUI
          template_generator = Redbreast::TemplateGenerator::Color::SwiftUI
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
