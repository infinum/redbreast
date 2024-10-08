# Parsing

require 'yaml'
require 'erb'

# Helpers
require 'redbreast/helpers/terminal'
require 'redbreast/helpers/general'
require 'redbreast/helpers/hash'

# Commands
require 'redbreast/commands/setup'
require 'redbreast/commands/image_generator'
require 'redbreast/commands/color_generator'
require 'redbreast/commands/image_test_generator'
require 'redbreast/commands/color_test_generator'
require 'redbreast/commands/configuration_installer'

# File Accessors
require 'redbreast/io/config'

# Crawlers
require 'redbreast/crawlers/image_crawler'
require 'redbreast/crawlers/color_crawler'

# Serializers
require 'redbreast/serializers/serializer'
require 'redbreast/serializers/objc_serializer'
require 'redbreast/serializers/swift_serializer'
require 'redbreast/serializers/swiftui_serializer'

# Template generators
require 'redbreast/template_generators/objc_template_generator'
require 'redbreast/template_generators/swift_template_generator'
require 'redbreast/template_generators/swiftui_template_generator'
require 'redbreast/template_generators/images/objc_images_template_generator'
require 'redbreast/template_generators/images/swift_images_template_generator'
require 'redbreast/template_generators/images/swiftui_images_template_generator'
require 'redbreast/template_generators/colors/objc_colors_template_generator'
require 'redbreast/template_generators/colors/swift_colors_template_generator'
require 'redbreast/template_generators/colors/swiftui_colors_template_generator'
require 'redbreast/template_generators/tests/colors/objc_colors_tests_template_generator'
require 'redbreast/template_generators/tests/colors/swift_colors_tests_template_generator'
require 'redbreast/template_generators/tests/colors/swiftui_colors_tests_template_generator'
require 'redbreast/template_generators/tests/images/objc_images_tests_template_generator'
require 'redbreast/template_generators/tests/images/swift_images_tests_template_generator'
require 'redbreast/template_generators/tests/images/swiftui_images_tests_template_generator'

# Error Handler
require 'redbreast/error_handler'

# Version
require 'redbreast/version'

# Program used for creating images and colors
module Redbreast
end
