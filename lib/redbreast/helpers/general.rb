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
  
      end
    end
  end