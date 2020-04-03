require_relative 'serializer' 

module Redbreast
  module Serializer
    # Used for saving and creating ObjC files
    class ObjC < Base
      include Helper::General

      def save(output_source_path:, template_generator:, generate_colors:)
        FileUtils.mkdir_p output_source_path unless File.exist? output_source_path

        file_base_name = generate_colors ? 'UIColor' : 'UIImage'
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

      def create_objc_test_cases(names:, variable_declaration:, variable_end: '];')
        text = ''
        names.each do |name|
          temp_array = name.split('/')
          variable_name = temp_array.length == 1 ? clean_variable_name(name) : temp_array.unshift(temp_array.shift.downcase).join('')
          text += "\t" + variable_declaration + variable_name + variable_end
          text += name == names.last ? '' : "\n"
        end
        text
      end

      def generate_m_file_objc(names:, variable_declaration:, variable_type:, variable_end: "\" inBundle:", bundle_name:, last_part: " compatibleWithTraitCollection:nil];\n}\n")
        text = ''

        names.each do |name|
          temp_arr = name.split('/')
          variable_name = temp_arr.length == 1 ? clean_variable_name(name) : temp_arr.unshift(temp_arr.shift.downcase).join('')
          text += variable_declaration + variable_name + variable_type + name + variable_end + bundle_name[:reference] + last_part
          text += name == names.last ? '' : "\n"
        end

        text
      end

      def generate_h_file_objc(names:, variable_declaration:, variable_end: ';')
        text = ''

        names.each do |name|
          temp_arr = name.split('/')
          variable_name = temp_arr.length == 1 ? clean_variable_name(name) : temp_arr.unshift(temp_arr.shift.downcase).join('')
          text += variable_declaration + variable_name + variable_end + "\n"
        end

        text
      end

      def generate_category(type, class_name, app_name)
        text = "@#{type}  #{class_name} ("

        return text += 'Common)\n' if app_name.nil? || app_name.empty?

        text + app_name + ")\n"
      end
    end
  end
end
