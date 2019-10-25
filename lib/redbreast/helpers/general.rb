module Redbreast
    module Helper
      module General
        ESCAPE_KEYWORDS = ["associatedtype", "class", "deinit", "enum", "extension", "fileprivate", "func", 
                           "import", "init", "inout", "internal", "let", "operator", "private", "protocol", 
                           "public", "static", "struct", "subscript", "typealias", "var", "break", "case", 
                           "continue", "default", "defer", "do", "else", "fallthrough", "for", "guard", "if", 
                           "in", "repeat", "return", "switch", "where", "while", "as", "Any", "catch", "false", 
                           "is", "nil", "rethrows", "super", "self", "Self", "throw", "throws", "true", "try", "_"]
    
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
  
        def indent(level = 0, initial = "")
          (1..level)
            .to_a.reduce("") { |result, value| result + "    " }
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
          "_" + name
        end
  
        def escape_keyword_if_needed(name)
          return name if !ESCAPE_KEYWORDS.include? name
          "`#{name}`"
        end

        def generate_file(color_names, spacing, previous_level, variable_declaration, variable_type, variable_end)
          return if color_names.empty?
          text = ""
          arr = []
      
          color_names.each do |name|
              temp_arr = name.split("/")
      
              if temp_arr.length != 1
                  arr.push(temp_arr.first)
              else
                  name_prefix = previous_level.empty? ? "" : "/"

                  text += spacing + variable_declaration + clean_variable_name(name) + variable_type + previous_level + name_prefix + name + variable_end
                  text += name == color_names.last ? "" : "\n"
              end
          end
      
          arr = arr.uniq
          text += previous_level.empty? ? "\n" : ""
          arr.each do |struct_name|
              color_names_new = []
              color_names_new_struct = []
              new_struct_name = struct_name
      
              text += "\n" + spacing + "struct " + struct_name + " {"
              
              color_names.each do |name|
                  temp_arr = name.split("/")
                  
                  if temp_arr.length == 1
                      next
                  elsif temp_arr.length > 2
                      if temp_arr.first == new_struct_name
                          color_names_new_struct.push(temp_arr.drop(1).join("/"))
                      end
                      next
                  end
      
                  if temp_arr[0] == struct_name
                      color_names_new.push(temp_arr.drop(1).join("/"))
                  end
              end
      
              if !color_names_new_struct.empty? && new_struct_name == struct_name
                 
                  previous_level += previous_level.empty? ? "" : "/"
                  text += "\n" + generate_file(color_names_new_struct, spacing + "\t", previous_level + struct_name, variable_declaration, variable_type, variable_end)
                  color_names_new_struct = []
              end
      
              if color_names_new.length != 0
                  previous_level += previous_level.empty? ? "" : "/"
                  
                  text += "\n" + generate_file(color_names_new, spacing + "\t", previous_level + struct_name, variable_declaration, variable_type, variable_end)
              end
      
              text += "\n" +  spacing  + "}" + "\n"
          end
          return text
        end

        def application_name(app_name)
          return app_name
        end
  
      end
    end
  end