module Redbreast
    module Crawler
      class Color
  
        def self.color_names_uniq(assets_search_path)
          Dir.glob(assets_search_path).flat_map { |asset_folder|
              Dir.glob("#{asset_folder}/**/*.colorset").map { |color_name|

                name_to_split = color_name
                split_name = name_to_split.split(".xcassets/")
                current_color_name = split_name[0] + ".xcassets/"
                current_iterating_name = split_name[0] + ".xcassets/"

                for folder in split_name[1].split("/") do 
                  if folder.include?  ".colorset"
                    current_color_name += folder
                    next
                  end

                  current_iterating_name += folder + "/"

                  Dir.glob("#{current_iterating_name}*.json").map { |path_name|
                    File.open path_name do |file|
                        if !file.find { |line| line =~ /provides/ }.nil?
                          current_color_name += folder + "/"
                          next
                        end
                    end
                  }
                end 

                puts current_color_name
                current_color_name.split(".xcassets/")[-1].chomp(".colorset")
              }
            }
            .uniq
        end
  
      end
    end
  end