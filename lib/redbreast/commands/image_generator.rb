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
            
            write_images(image_names, bundle[:reference], bundle[:outputSourcePath], programming_language)
          end
        end
  
        # Serializing data
  
        def write_images(image_names, bundle_reference, output_path, programming_language)
          return if output_path.to_s.empty?
          case programming_language.downcase
          when "objc"
            serializer = Redbreast::Serializer::Image::ObjC
          when "swift"
            serializer = Redbreast::Serializer::Image::Swift
          end
          serializer.new(image_names, bundle_reference).save(output_path)
        end
  
        # Pulling data
  
        def pull_asset_names(assetsSearchPath)
            Redbreast::Crawler::Image
            .image_names_uniq(assetsSearchPath)
        end
  
      end
    end
  end
  