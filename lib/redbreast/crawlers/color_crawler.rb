module Redbreast
    module Crawler
      class Color
  
        def self.color_names_uniq(assets_search_path)
          Dir.glob(assets_search_path).flat_map { |asset_folder|
              Dir.glob("#{asset_folder}/**/*.colorset").map { |color_name|
                # arr = color_name.split(".xcassets/")
                # arr4 = arr.take(1)
                # puts arr
                # puts arr4
              
                color_name.split(".xcassets/")[-1].chomp(".colorset")
                # arr[-2] + "/" + arr[-1] 

                # color_name.split("/")[-1].chomp(".colorset")
              }
            }
            .uniq
        end
  
      end
    end
  end