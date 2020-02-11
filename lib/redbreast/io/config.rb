# frozen_string_literal: true

module Redbreast
  module IO
    # Used for reading and writing to config file
    class Config
      CONFIG_FILE_PATH = "#{Dir.pwd}/.redbrest.yml"

      class << self
        def write(data)
          File.open(CONFIG_FILE_PATH, 'w') { |file| YAML.dump(data, file) }
        end

        def read
          YAML.load_file(CONFIG_FILE_PATH)
        end
      end
    end
  end
end
