require 'commander/blank'
require 'commander/command'

module Redbreast
    module Command
      class Setup
        include Helper::Terminal
        include Helper::General
  
        def self.init(options = Commander::Command::Options.new)
          new(options).call
        end
      
        def initialize(options = Commander::Command::Options.new)
          @options = options
        end
  
        def call
          language = language_prompt
          bundle_names = bundle_names_prompt(language).split(" ")
          bundles = bundle_names.map do |bundle| 
            {
                name: bundle,
                reference: bundle_reference(bundle, language),
                assetsSearchPath: assets_search_path_prompt(bundle),
                outputSourcePath: images_sources_path_prompt(bundle, language)
            }
          end
          config = {
            language: language,
            bundles: bundles
          }
          Redbreast::IO::Config.write(config)
          success
        end
  
        private
        
        # Language
  
        def language_prompt
          languages = {'Swift' => 'swift', 'Objective-C' => 'objc'}
          prompt.select('Choose a language: ', languages)
        end
  
        # Assets source path

        def assets_search_path_prompt(bundle)
          prompt.ask("Please enter assets folder search paths for bundle #{bundle}?", default: '**/*.xcassets')
        end

        # Bundle names promt
        
        def bundle_names_prompt(language)
            case language
            when "objc"
              prompt.ask('Please enter bundle names that you use separated by spaces', default: 'mainBundle')
            when "swift"
              prompt.ask('Please enter bundle names that you use separated by spaces', default: 'main')
            end
        end

        def bundle_reference(bundle_name, language)
          case language
          when "objc"
            "[NSBundle #{bundle_name}]"
          when "swift"
            ".#{bundle_name}"
          end
        end

        # Images source path

        def images_sources_path_prompt(bundle, language)
          case language
          when "objc"
            prompt.ask("Where would you like to store images resources files for bundle #{bundle}?", default: './Common/Categories/Images')
          when "swift"
            prompt.ask("Where would you like to store images resources files for bundle #{bundle}?", default: './Common/Extensions/UIImageExtension.swift')
          end
        end

      end
    end
  end