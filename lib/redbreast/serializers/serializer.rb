module Redbreast
    module Serializer
        class Base
          include ERB::Util
          attr_accessor :asset_names, :bundle
  
          def initialize(asset_names, bundle, app_name)
            @asset_names = asset_names
            @bundle = bundle
            @app_name = app_name
          end
  
          def save(path)
            fail NotImplementedError, 'Abstract Method'
          end
  
        end
    end
  end