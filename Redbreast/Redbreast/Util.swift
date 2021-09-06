//
//  Util.swift
//  Redbreast
//
//  Created by Maroje Marcelić on 03/09/2021.
//

import Foundation


class Util {


    static func convertToUpperCamelCase(name: String) -> String {

        let cleanName = name.camelized.uppercasingFirst


        print(cleanName)
        return cleanName
    }

    static func convertToLowerCamelCase(name: String) -> String {

        let cleanName = name.camelized.lowercasingFirst

        print(cleanName)
        return cleanName
    }
}


//clean_name = name
//             .split(/[^0-9a-zA-Z]/)
//             .reject(&:empty?)
//             .each_with_index
//             .map { |v, i| i.zero? ? v.tap { |char| char[0] = char[0].upcase } : v.capitalize }
//             .join
fileprivate let badChars = CharacterSet.alphanumerics.inverted

extension String {
    var uppercasingFirst: String {
        return prefix(1).uppercased() + dropFirst()
    }

    var lowercasingFirst: String {
        return prefix(1).lowercased() + dropFirst()
    }

    var camelized: String {
        guard !isEmpty else {
            return ""
        }

        let parts = self.components(separatedBy: badChars)

        let first = String(describing: parts.first!).lowercasingFirst
        let rest = parts.dropFirst().map({String($0).uppercasingFirst})

        return ([first] + rest).joined(separator: "")
    }
}
