require_relative 'serializer'

module Redbreast
  module Serializer
      class ObjC < Base
        include Helper::General

        def save(output_source_path, template_generator)
          FileUtils.mkdir_p output_source_path unless File.exist? output_source_path

          name = File.basename(output_source_path)

          if template_generator.h_template
            h_file = ERB.new(template_generator.h_template, nil, '-').result(binding)
            File.write(File.join(output_source_path, "UIImage+#{name}.h"), h_file)
          end
          
          if template_generator.m_template
            m_file = ERB.new(template_generator.m_template, nil, '-').result(binding)
            File.write(File.join(output_source_path, "UIImage+#{name}.m"), m_file)
          end
          
        end

    end
  end
end
