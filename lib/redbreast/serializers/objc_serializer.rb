require_relative 'serializer' # frozen_string_literal: true

module Redbreast
  module Serializer
    # Used  for saving ObjC files
    class ObjC < Base
      include Helper::General

      def save(output_source_path, template_generator)
        FileUtils.mkdir_p output_source_path unless File.exist? output_source_path

        file_base_name = File.basename(output_source_path) == 'Colors' ? 'UIColor' : 'UIImage'
        name = app_name.nil? ? 'Common' : app_name

        if template_generator.h_template
          write(output_source_path, template_generator.h_template, "#{file_base_name}+#{name}.h")
        end

        return unless template_generator.m_template

        write(output_source_path, template_generator.m_template, "#{file_base_name}+#{name}.m")
      end

      def write(output_source_path, template, file_name)
        file = ERB.new(template, nil, '-').result(binding)
        File.write(File.join(output_source_path, file_name), file)
      end
    end
  end
end
