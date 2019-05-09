require 'commander/blank'
require 'commander/command'

module Redbreast
    module Command
      class Setup < Projects
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
          images_sources_path_prompt = sources_path_prompt
          project = {
            imagesSourceFilesPath: images_sources_path_prompt
          }
          config = {
            language: language,
            project: project
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
  
        # Images source path
  
        def images_sources_path_prompt
          prompt.ask('Where would you like to store images source files?', default: './Common/Extensions/')
        end
  
      end
    end
  end