# Parsing
require "yaml"
require "erb"

# Helpers
require "redbreast/helpers/terminal"
require "redbreast/helpers/general"

# Commands
require "redbreast/commands/setup"
require "redbreast/commands/image_generator"

# File Accessors
require "redbreast/io/config"

# Crawlers
require "redbreast/crawlers/image_crawler"

# Serializers
require 'redbreast/serializers/images/images_serializer'
require 'redbreast/serializers/images/objc_images_serializer'
require 'redbreast/serializers/images/swift_images_serializer'

# Error Handler
require "redbreast/error_handler"

# Version
require "redbreast/version"


module Redbreast

end