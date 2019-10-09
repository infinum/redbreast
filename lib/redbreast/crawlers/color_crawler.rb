module Redbreast
    module Crawler
      class Color
  
        def self.color_names_uniq(assets_search_path)
          Dir.glob(assets_search_path).flat_map { |asset_folder|
              Dir.glob("#{asset_folder}/**/*.coloret").map { |color_name|
                  color_name.split("/")[-1].chomp(".colorset")
              }
            }
            .uniq
        end
  
      end
    end
  end