module Redbreast
  module Crawler
    # Class for finding images
    class Image
      def self.image_names_uniq(assets_search_path)
        Dir.glob(assets_search_path).flat_map do |asset_folder|
          Dir.glob("#{asset_folder}/**/*.imageset").map do |image_name|
            name_to_split = image_name
            split_name = name_to_split.split('.xcassets/')
            current_image_name = split_name[0] + '.xcassets/'
            current_iterating_name = split_name[0] + '.xcassets/'

            split_name[1].split('/').each do |folder|
              if folder.include?  '.imageset'
                current_image_name += folder
                next
              end

              current_iterating_name += folder + '/'

              Dir.glob("#{current_iterating_name}*.json").map do |path_name|
                File.open path_name do |file|
                  unless file.find { |line| line =~ /provides/ }.nil?
                    current_image_name += folder + '/'
                    next
                  end
                end
              end
            end

            current_image_name.split('.xcassets/')[-1].chomp('.imageset')
          end
        end
           .uniq
      end
    end
  end
end
