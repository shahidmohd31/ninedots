//
//  Modal.swift
//  ninedot
//
//  Created by mohd shahid on 25/08/24.
//

struct Category: Codable {
    let name: String
    let image: String
    let fruits: [String]
}

struct DataModel: Codable {
    let categories: [Category]
}
