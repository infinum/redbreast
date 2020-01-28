module Redbreast
  module Helper
    module General
      ESCAPE_KEYWORDS = ['associatedtype', 'class', 'deinit', 'enum', 'extension', 'fileprivate', 'func', 
                          'import', 'init', 'inout', 'internal', 'let', 'operator', 'private', 'protocol', 
                          'public', 'static', 'struct', 'subscript', 'typealias', 'var', 'break', 'case', 
                          'continue', 'default', 'defer', 'do', 'else', 'fallthrough', 'for', 'guard', 'if', 
                          'in', 'repeat', 'return', 'switch', 'where', 'while', 'as', 'Any', 'catch', 'false', 
                          'is', 'nil', 'rethrows', 'super', 'self', 'Self', 'throw', 'throws', 'true', 'try', '_']
  
      def config
        @config ||= Redbreast::IO::Config.read
      end

      def programming_language
        @programming_language ||= config[:language]
      end

      def bundles
        @bundles ||= config[:bundles]
      end

      def app_name
        @app_name ||= config[:app_name]
      end

      def indent(level = 0, initial = '')
        (1..level)
          .to_a.reduce('') { |result, value| result + '    ' }
          .concat(initial)
      end

      def clean_enum_name(name)
        clean_name = name
          .split(/[^0-9a-zA-Z]/)
          .reject { |c| c.empty? }
          .map { |value| value.capitalize }
          .join

        escape_with_underscore_if_needed(clean_name)
      end

      def clean_case_name(name)
        clean_variable_name(name)
      end

      def clean_variable_name(name)
        clean_name = name
          .split(/[^0-9a-zA-Z]/)
          .reject { |c| c.empty? }
          .each_with_index
          .map { |value, index| index == 0 ? value.tap { |char| char[0] = char[0].downcase } : value.capitalize }
          .join

        escaped_underscore = escape_with_underscore_if_needed(clean_name)
        escape_keyword_if_needed(escaped_underscore)
      end
      
      def escape_with_underscore_if_needed(name)
        return name if name.match(/^[A-Za-z_]/)
        '_' + name
      end

      def escape_keyword_if_needed(name)
        return name if !ESCAPE_KEYWORDS.include? name
        "`#{name}`"
      end

      def generate_file_swift(names, spacing, previous_level, variable_declaration, variable_type, variable_end, bundle, last_part)
        return if names.empty?
        text = ''
        arr = []
    
        names.each do |name|
            temp_arr = name.split('/')
    
            if temp_arr.length != 1
                arr.push(temp_arr.first)
            else
                name_prefix = previous_level.empty? ? '' : '/'

                text += spacing + variable_declaration + clean_variable_name(name) + variable_type + previous_level + name_prefix + name + variable_end + bundle[:reference] + last_part
                text += name == names.last ? '' : '\n'
            end
        end
    
        arr = arr.uniq
        text += previous_level.empty? ? '\n' : ''
        arr.each do |enum_name|
            names_new = []
            names_new_enum = []
            new_enum_name = enum_name
    
            text += '\n' + spacing + 'enum ' + enum_name + ' {'
            
            names.each do |name|
                temp_arr = name.split('/')
                
                if temp_arr.length == 1
                    next
                elsif temp_arr.length > 2
                    if temp_arr.first == new_enum_name
                        names_new_enum.push(temp_arr.drop(1).join('/'))
                    end
                    next
                end
    
                if temp_arr[0] == enum_name
                    names_new.push(temp_arr.drop(1).join('/'))
                end
            end
    
            if !names_new_enum.empty? && new_enum_name == enum_name
                
                previous_level += previous_level.empty? ? '' : '/'
                text += '\n' + generate_file_swift(names_new_enum, spacing + '\t', previous_level + enum_name, variable_declaration, variable_type, variable_end, bundle, last_part)
                names_new_enum = []
            end
    
            if names_new.length != 0
                previous_level += previous_level.empty? ? '' : '/'
                
                text += '\n' + generate_file_swift(names_new, spacing + '\t', previous_level + enum_name, variable_declaration, variable_type, variable_end, bundle, last_part)
            end
    
            text += '\n' +  spacing  + '}' + '\n'
        end
        return text
      end

      def generate_extension(extended_class, app_name)
        text = 'extension ' + extended_class + ' {\n'

        if app_name.nil? || app_name.empty?
          return text
        end
        text += '\tenum ' + app_name + ' {}\n}\n\nextension ' + extended_class + '.' + app_name + ' {\n' 

        return text
      end

      def generate_m_file_objc(names, variable_declaration, variable_type, variable_end, bundle_name, last_part)
        text = ''

        names.each do |name|
          temp_arr = name.split('/')
          variable_name = temp_arr.length == 1 ? clean_variable_name(name) : temp_arr.unshift(temp_arr.shift.downcase).join('')
          text += variable_declaration + variable_name + variable_type + name + variable_end + bundle_name[:reference] + last_part
          text += name == names.last ? '' : '\n'
        end

        return text
      end

      def generate_h_file_objc(names, variable_declaration, variable_end)
        text = ''

        names.each do |name|
          temp_arr = name.split('/')
          variable_name = temp_arr.length == 1 ? clean_variable_name(name) : temp_arr.unshift(temp_arr.shift.downcase).join('')
          text += variable_declaration + variable_name +  variable_end + '\n'
        end

        return text
      end

      def generate_category(type, class_name, app_name)
        text = '@' + type + ' ' + class_name + ' ('
        
        if app_name.nil? || app_name.empty?
          return text += 'Common)\n'
        end 

        return text += app_name + ')\n'
      end

      def create_swift_test_cases(names, variable_declaration, app_name)
        text = ''
        app_name_text = app_name.nil? || app_name.empty? ? '' : app_name + '.'

        names.each do |name|  
          temp_array = name.split('/')
          variable = temp_array.pop
          additional_text = temp_array.count == 0 ? '' : '.'
          text += '\t\t' + variable_declaration + app_name_text + temp_array.join('.') + additional_text + clean_variable_name(variable)
          text += name == names.last ? '' : '\n'
        end
        return text
      end

      def create_objc_test_cases(names, variable_declaration, variable_end)
        text = ''

        names.each do |name|  
          temp_array = name.split('/')
          variable_name = temp_array.length == 1 ? clean_variable_name(name) : temp_array.unshift(temp_array.shift.downcase).join('')
          text += '\t' + variable_declaration + variable_name + variable_end
          text += name == names.last ? '' : '\n'
        end
        
        return text
      end

    end
  end
end
