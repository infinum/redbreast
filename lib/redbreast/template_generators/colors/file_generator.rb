module Redbreast
    module TemplateGenerator
        class FileGenerator

            def generate_file(color_names, spacing, previous_level)
                return if color_names.empty?
                text = ""
                arr = []
            
                color_names.each do |name|
                    temp_arr = name.split("/")
            
                    if temp_arr.length != 1
                        arr.push(temp_arr.first)
                    else
                        name_prefix = previous_level.empty? ? "" : "/"
                        if name == color_names.last
                            text += spacing + 'static var ' + clean_variable_name(name) + ': UIColor { return UIColor(named: "' + previous_level + name_prefix + name + '")! }'
                        else
                            text += spacing + 'static var ' + clean_variable_name(name) + ': UIColor { return UIColor(named: "' + previous_level + name_prefix + name + '")! }' + "\n"
                        end
                    end
                end
            
                arr = arr.uniq
            
                arr.each do |struct_name|
                    color_names_new = []
                    color_names_new_struct = []
                    new_struct_name = struct_name
            
                    text = text.empty? ? text : text + "\n" 
                    text += spacing + 'struct ' + struct_name + ' {'
                    
                    color_names.each do |name|
                        temp_arr = name.split("/")
                        
                        if temp_arr.length == 1
                            next
                        elsif temp_arr.length > 2
                            if temp_arr.first == new_struct_name
                                color_names_new_struct.push(temp_arr.drop(1).join("/"))
                            end
                            next
                        end
            
                        if temp_arr[0] == struct_name
                            color_names_new.push(temp_arr.drop(1).join("/"))
                        end
                    end
            
                    if !color_names_new_struct.empty? && new_struct_name == struct_name
                       
                        previous_level += previous_level.empty? ? "" : "/"
                        text += "\n\n" + test(color_names_new_struct, spacing + "\t", previous_level + struct_name)
                        color_names_new_struct = []
                    end
            
                    if color_names_new.length != 0
                        previous_level += previous_level.empty? ? "" : "/"
                        
                        text += "\n" + test(color_names_new, spacing + "\t", previous_level + struct_name)
                    end
            
                    text += "\n" +  spacing  + '}' + "\n"
                end
                return text
            end
        end
    end
end