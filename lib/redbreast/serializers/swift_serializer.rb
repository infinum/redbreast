require_relative 'serializer' 

module Redbreast
  module Serializer
    # Used to save swift files
    class Swift < Base
      include Helper::General

      def save(output_source_path, template_generator)
        directory = File.dirname(output_source_path)
        FileUtils.mkdir_p directory unless File.exist? directory

        file = ERB.new(template_generator.template, nil, '-').result(binding)
        File.write(output_source_path, file)
      end

      def generate_file_swift(names, spacing, indentation, declaration, type, var_end, bundle, line_end)

        return if names.empty?

        text = ''
        arr = []

        names.each do |name|
          temp_arr = name.split('/')

          if temp_arr.length != 1
            arr.push(temp_arr.first)
          else
            name_prefix = indentation.empty? ? '' : '/'
            text += spacing + declaration + clean_variable_name(name) + type + indentation + name_prefix + name + var_end + bundle[:reference] + line_end
            text += name == names.last ? '' : "\n"
          end
        end

        arr = arr.uniq
        text += indentation.empty? && text.empty? ? "\n" : ''
        arr.each do |enum_name|
          names_new = []
          names_new_enum = []
          new_enum_name = enum_name

          text += "\n" + spacing + 'enum ' + enum_name + ' {'

          names.each do |name|
            temp_arr = name.split('/')

            next if temp_arr.length == 1

            if temp_arr.length > 2
              names_new_enum.push(temp_arr.drop(1).join('/')) if temp_arr.first == new_enum_name
              next
            end

            names_new.push(temp_arr.drop(1).join('/')) if temp_arr[0] == enum_name
          end

          if !names_new_enum.empty? && new_enum_name == enum_name
            indentation += (indentation.empty? || indentation[-1] == '/') ? '' : '/'
            text += "\n" + generate_file_swift(names_new_enum, spacing + "\t", indentation + enum_name, declaration, type, var_end, bundle, line_end)
            names_new_enum = []
          end

          unless names_new.empty?

            indentation += (indentation.empty? || indentation[-1] == '/') ? '' : '/'
            text += "\n" + generate_file_swift(names_new, spacing + "\t", indentation + enum_name, declaration, type, var_end, bundle, line_end)
          end

          text += "\n" + spacing + '}' + "\n"
        end
        text
      end

      def generate_extension(extended_class, app_name)
        text = 'extension ' + extended_class + " {"

        return text if app_name.nil? || app_name.empty?

        text + "\tenum " + app_name + " {}\n}\n\nextension " + extended_class + '.' + app_name + " {\n"
      end

      def create_swift_test_cases(names, declaration, app_name)
        text = ''
        app_name_text = app_name.nil? || app_name.empty? ? '' : app_name + '.'

        names.each do |name|
          temp_array = name.split('/')
          variable = temp_array.pop
          additional_text = temp_array.count.zero? ? '' : '.'
          text += "\t\t" + declaration + app_name_text + temp_array.join('.') + additional_text + clean_variable_name(variable)
          text += name == names.last ? '' : "\n"
        end

        text
      end
    end
  end
end
