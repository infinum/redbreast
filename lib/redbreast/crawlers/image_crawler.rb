module Redbreast
  module Crawler
    class Image

      def self.image_names_uniq(assets_search_path)
        Dir.glob(assets_search_path).flat_map { |asset_folder|
            Dir.glob("#{asset_folder}/**/*.imageset").map { |image_name|
                image_name.split("/")[-1].chomp(".imageset")
            }
          }
          .uniq
      end

    end
  end
end

      