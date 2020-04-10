module Redbreast
  module Serializer
    # Used for initializing a serializer which will save files for respective languages
    class Base
      include ERB::Util
      attr_accessor :asset_names, :bundle

      def initialize(asset_names, bundle, app_name)
        @asset_names = asset_names
        @bundle = bundle
        @app_name = app_name
      end

      def save(*)
        raise NotImplementedError, 'Abstract Method'
      end
    end
  end
end
