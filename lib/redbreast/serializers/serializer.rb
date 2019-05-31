module Redbreast
    module Serializer
        class Base
          include ERB::Util
          attr_accessor :image_names, :bundle
  
          def initialize(image_names, bundle)
            @image_names = image_names
            @bundle = bundle
          end
  
          def save(path)
            fail NotImplementedError, 'Abstract Method'
          end
  
        end
    end
  end