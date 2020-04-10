module Redbreast
  module Helper
    # Module with general metods used in creating files
    module General
      ESCAPE_KEYWORDS = ['associatedtype', 'class', 'deinit', 'enum', 'extension',
                         'fileprivate', 'func', 'import', 'init', 'inout',
                         'internal', 'let', 'operator', 'private', 'protocol',
                         'public', 'static', 'struct', 'subscript', 'typealias',
                         'var', 'break', 'case', 'continue', 'default',
                         'defer', 'do', 'else', 'fallthrough', 'for',
                         'guard', 'if', 'in', 'repeat', 'return',
                         'switch', 'where', 'while', 'as', 'Any',
                         'catch', 'false', 'is', 'nil', 'rethrows',
                         'super', 'self', 'Self', 'throw', 'throws',
                         'true', 'try', '_'].freeze
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
          .to_a.reduce('') { |result, _| result + '    ' }
          .concat(initial)
      end

      def clean_enum_name(name)
        clean_name = name
                     .split(/[^0-9a-zA-Z]/)
                     .reject(&:empty?)
                     .map(&:capitalize)
                     .join

        escape_with_underscore_if_needed(clean_name)
      end

      def clean_case_name(name)
        clean_variable_name(name)
      end

      def clean_variable_name(name)
        clean_name = name
                     .split(/[^0-9a-zA-Z]/)
                     .reject(&:empty?)
                     .each_with_index
                     .map { |v, i| i.zero? ? v.tap { |char| char[0] = char[0].downcase } : v.capitalize }
                     .join

        escaped_underscore = escape_with_underscore_if_needed(clean_name)
        escape_keyword_if_needed(escaped_underscore)
      end

      def escape_with_underscore_if_needed(name)
        return name if name.match(/^[A-Za-z_]/)

        '_' + name
      end

      def escape_keyword_if_needed(name)
        return name unless ESCAPE_KEYWORDS.include? name

        "`#{name}`"
      end
    end
  end
end
