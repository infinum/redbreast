//
//  main.swift
//  Redbreast
//
//  Created by Maroje Marcelić on 31/08/2021.
//

import Foundation


let c = Crawler()
let images = c.findNames(for: "images", in: ".")

Input.writeToFile(assets: images, bundle: "lolol", appName: "PGC")
//Input.writeToFile(string: "//\(images.joined())")

//Input.readFile()
