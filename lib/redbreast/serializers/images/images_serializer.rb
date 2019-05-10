module Redbreast
    module Serializer
      module Image
        class Base
          include ERB::Util
          attr_accessor :image_names, :bundle_reference
  
          def initialize(image_names, bundle_reference)
            @image_names = image_names
            @bundle_reference = bundle_reference
          end
          
          def render()
            ERB.new(template, nil, '-').result(binding)
          end
  
          def template()
            fail NotImplementedError, 'Abstract Method'
          end
  
          def save(path)
            fail NotImplementedError, 'Abstract Method'
          end
  
        end
      end
    end
  end