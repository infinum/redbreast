module Redbreast
    module Command
      class ImageGenerator
        include Helper::Terminal
        include Helper::General
  
        def self.init
          new.call
        end
  
        def call
          prompt.say("Generating image resources...")
          generate_image_sources(bundles, programming_language)
          success("Image resources generated!")
        end
  
        private
  
        def generate_image_sources(bundles, programming_language)
          bundles.each do |bundle|
            image_names = pull_asset_names(bundle[:assetsSearchPath])
            write_images(image_names, bundle, programming_language)
          end
        end
  
        # Serializing data
  
        def write_images(image_names, bundle, programming_language)
          output_path = bundle[:outputSourcePathImages]
          return if output_path.to_s.empty?
          case programming_language.downcase
          when "objc"
            serializer = Redbreast::Serializer::ObjC
            template_generator = Redbreast::TemplateGenerator::Image::ObjC
          when "swift"
            serializer = Redbreast::Serializer::Swift
            template_generator = Redbreast::TemplateGenerator::Image::Swift
          end
          serializer.new(image_names, nil, bundle).save(output_path, template_generator.new)
        end
  
        # Pulling data
  
        def pull_asset_names(assetsSearchPath)
            Redbreast::Crawler::Image
            .image_names_uniq(assetsSearchPath)
        end
  
      end
    end
  end
  