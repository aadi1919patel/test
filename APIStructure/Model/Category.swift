//
//  Category.swift
//  APIStructure
//
//  Created by Adi Patel on 01/03/21.
//

import Foundation

// MARK: - Welcome
class Welcome: Codable {
    let categories: [Category]

    init(categories: [Category]) {
        self.categories = categories
    }
}

// MARK: - Category
class Category: Codable {
    let id: Int
    let title: String
    let image: String

    init(id: Int, title: String, image: String) {
        self.id = id
        self.title = title
        self.image = image
    }
}
