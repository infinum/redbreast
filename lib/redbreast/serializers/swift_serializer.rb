require_relative 'serializer' 

module Redbreast
  module Serializer
    # Used to save swift files
    class Swift < Base
      include Helper::General
      SPACER = "    "

      def save(output_source_path:, template_generator:, generate_colors:)
        directory = File.dirname(output_source_path)
        FileUtils.mkdir_p directory unless File.exist? directory

        file = ERB.new(template_generator.template, nil, '-').result(binding)
        File.write(output_source_path, file)
      end

      def generate_file_swift(names:, spacing: SPACER, indentation: '', variable:, bundle:)
        return if names.empty?

        text = ''
        arr = []

        vars, arr = generate_variables(names: names, spacing: spacing, indentation: indentation, variable: variable, bundle: bundle, text: text, array: arr)

        arr = arr.uniq.sort_by(&:downcase)

        arr.each do |enum_name|
          names_new = []
          names_new_enum = []
          new_enum_name = enum_name

          text += "\n" + spacing + 'enum ' + upper_camel_case(enum_name) + ' {'
          names_new, names_new_enum = separate_variables_from_folders(names: names, enum_name: enum_name, new_enum_name: new_enum_name, names_new_enum: names_new_enum, names_new: names_new)

          if !names_new_enum.empty? && new_enum_name == enum_name
            indentation += indentation.empty? || indentation[-1] == '/' ? '' : '/'
            text += "\n" + generate_file_swift(names: names_new_enum, spacing: spacing + SPACER, indentation: indentation + enum_name, variable: variable, bundle: bundle)
          end

          unless names_new.empty?

            indentation += indentation.empty? || indentation[-1] == '/' ? '' : '/'
            text += generate_file_swift(names: names_new, spacing: spacing + SPACER, indentation: indentation + enum_name, variable: variable, bundle: bundle)
          end

          text += "\n" + spacing + '}' + "\n"
        end
        text + vars
      end

      def generate_extension(extended_class, app_name)
        text = 'extension ' + extended_class + " {\n"

        return text if app_name.nil? || app_name.empty?

        text + SPACER + "enum " + app_name + " {}\n}\n\nextension " + extended_class + '.' + app_name + " {"
      end

      def create_swift_test_cases(names:, declaration:, app_name:)
        text = ''
        app_name_text = app_name.nil? || app_name.empty? ? '' : app_name + '.'

        names.each do |name|
          temp_array = name.split('/')
          variable = temp_array.pop
          additional_text = temp_array.count.zero? ? '' : '.'

          text += SPACER + SPACER + declaration + app_name_text + temp_array.map { |enum| upper_camel_case(enum) }.join('.') + additional_text + clean_variable_name(variable)
          text += name == names.last ? '' : "\n"
        end

        text
      end

      def generate_variables(names:, spacing:, indentation:, bundle:, variable:, text:, array:)
        names.sort_by(&:downcase).each do |name|
          temp_arr = name.split('/')

          if temp_arr.length != 1
            array.push(temp_arr.first)
          else
            name_prefix = indentation.empty? ? '' : '/'
            text += "\n" + spacing + variable % [clean_variable_name(name), indentation + name_prefix + name, bundle[:reference]]
          end
        end

        [text, array]
      end

      def separate_variables_from_folders(names:, enum_name:, new_enum_name:, names_new_enum:, names_new:)
        names.each do |name|
          temp_arr = name.split('/')

          next if temp_arr.length == 1

          if temp_arr.length > 2
            names_new_enum.push(temp_arr.drop(1).join('/')) if temp_arr.first == new_enum_name
            next
          end

          names_new.push(temp_arr.drop(1).join('/')) if temp_arr[0] == enum_name
        end

        [names_new, names_new_enum]
      end
    end
  end
end
