module Redbreast
  module Command
    # Class for creating images
    class ImageGenerator
      include Helper::Terminal
      include Helper::General

      def self.init
        new.call
      end

      def call
        filtered_bundles = bundles.select { |bundle| bundle[:outputSourcePathImages] }
        return if filtered_bundles.empty?

        prompt.say('Generating image resources...')
        generate_image_sources(filtered_bundles, app_name)
        success('Image resources generated!')
      end

      private

      def generate_image_sources(bundles, app_name)
        bundles.each do |bundle|
          image_names = pull_asset_names(bundle[:assetsSearchPath])
          bundle_language = bundle[:language] || programming_language
          shouldOmitNamespace = bundle[:shouldOmitNamespace]
          namespace = shouldOmitNamespace ? '' : app_name
          write_images(image_names, bundle, bundle_language, namespace)
        end
      end

      # Serializing data

      def write_images(image_names, bundle, programming_language, app_name)
        output_path = bundle[:outputSourcePathImages]
        return if output_path.to_s.empty?

        case programming_language.downcase
        when 'objc'
          serializer = Redbreast::Serializer::ObjC
          template_generator = Redbreast::TemplateGenerator::Image::ObjC
        when 'swift'
          serializer = Redbreast::Serializer::Swift
          template_generator = Redbreast::TemplateGenerator::Image::Swift
        when 'swiftui'
          serializer = Redbreast::Serializer::SwiftUI
          template_generator = Redbreast::TemplateGenerator::Image::SwiftUI
        end
        serializer.new(image_names, bundle, app_name).save(output_source_path: output_path, template_generator: template_generator.new, generate_colors: false)

      end

      # Pulling data

      def pull_asset_names(assetsSearchPath)
        Redbreast::Crawler::Image
          .image_names_uniq(assetsSearchPath)
      end
    end
  end
end
