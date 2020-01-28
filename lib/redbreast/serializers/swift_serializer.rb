require_relative 'serializer' # frozen_string_literal: true

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
    end
  end
end
