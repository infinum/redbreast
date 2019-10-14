module Redbreast
    module Command
      class ColorGenerator
        include Helper::Terminal
        include Helper::General
  
        def self.init
          new.call
        end
  
        def call
          prompt.say("Generating color resources...")
          generate_color_sources(bundles, programming_language)
          success("Color resources generated!")
        end
  
        private
  
        def generate_color_sources(bundles, programming_language)
          bundles.each do |bundle|
            color_names = pull_asset_names(bundle[:assetsSearchPath])
            write_colors(color_names, bundle, programming_language)
          end
        end
  
        # Serializing data
  
        def write_colors(color_names, bundle, programming_language)
          output_path = bundle[:outputSourcePathColors]
          return if output_path.to_s.empty?
          case programming_language.downcase
          when "objc"
            serializer = Redbreast::Serializer::ObjC
            template_generator = Redbreast::TemplateGenerator::Color::ObjC
          when "swift"
            serializer = Redbreast::Serializer::Swift
            template_generator = Redbreast::TemplateGenerator::Color::Swift
          end
          serializer.new(nil, color_names, bundle).save(output_path, template_generator.new)
        end
  
        # Pulling data
  
        def pull_asset_names(assetsSearchPath)
            Redbreast::Crawler::Color
            .color_names_uniq(assetsSearchPath)
        end
  
      end
    end
  end
  