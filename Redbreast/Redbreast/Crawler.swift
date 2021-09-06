//
//  Crawler.swift
//  Redbreast
//
//  Created by Maroje Marcelić on 03/09/2021.
//

import Foundation

class Crawler {

    func findNames(for assets: String, in path: String) -> [String] {
        let names = info
            .split(separator: "\n")
            .map { sub -> String? in
                guard let splitString =  String(sub).components(separatedBy: ".xcassets/").last,
                      let asset = splitString.components(separatedBy: ".imageset").first
                else { return nil }
                return asset
            }
            .compactMap { $0 }
        return names
    }
}
