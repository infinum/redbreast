require_relative '../objc_template_generator'

module Redbreast
    module TemplateGenerator
        module Test
            class ObjC < TemplateGenerator::ObjC
                include ERB::Util

                def h_template()
                    nil
                end
                    
                def m_template()
<<-TEMPLATE

#import <XCTest/XCTest.h>
#import <"UIImage+<%= File.basename(bundle[:outputSourcePath]) %>.h">

@interface <%= File.basename(bundle[:outputTestPath]) %> : XCTestCase

@end

@implementation Test

- (void)testExample {
    <%- image_names.each do |name| -%>
    [UIImage clean_variable_name(name)];
    <%- end -%>
}

@end

TEMPLATE
                end

            end
        end
    end
  end