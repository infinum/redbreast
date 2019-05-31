module Redbreast
    module Command
      class TestGenerator
        include Helper::Terminal
        include Helper::General
  
        def self.init
          new.call
        end
  
        def call
          filtered_bundles = bundles.select { |bundle| bundle[:outputTestPath] }
          return if filtered_bundles.empty?

          prompt.say("Generating test resources...")
          generate_test_sources(bundles, programming_language)
          success("Test resources generated!")
        end
  
        private
  
        def generate_test_sources(bundles, programming_language)
            bundles.each do |bundle|
                image_names = pull_asset_names(bundle[:assetsSearchPath])
            
                write_tests(image_names, bundle, programming_language)
          end
        end
  
        # Serializing data
  
        def write_tests(image_names, bundle, programming_language)
          output_path = bundle[:outputTestPath]
          return if output_path.to_s.empty?
          case programming_language.downcase
          when "objc"
            serializer = Redbreast::Serializer::ObjC
            template_generator = Redbreast::TemplateGenerator::Test::ObjC
          when "swift"
            serializer = Redbreast::Serializer::Swift
            template_generator = Redbreast::TemplateGenerator::Test::Swift
          end
          serializer.new(image_names, bundle).save(output_path, template_generator.new)
        end
  
        # Pulling data
  
        def pull_asset_names(assetsSearchPath)
            Redbreast::Crawler::Image
            .image_names_uniq(assetsSearchPath)
        end
  
      end
    end
  end
  