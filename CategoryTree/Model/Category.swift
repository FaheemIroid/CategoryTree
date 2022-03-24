//
//  Category.swift
//  CategoryTree
//
//  Created by Faheem Hussain on 24/03/22.
//

import Foundation

struct CategoryData : Decodable {
    let category : [Category]?
}


struct Category : Decodable {
    let categoryid : Int?
    let categorycode : String?
    let categoryname : String?
    let categoryalise : String?
    let imageurl : String?
    let sublist : [Category]?
}



class CategoryCellItem {
    internal init(category: Category, level: CategoryLevel) {
        self.category = category
        self.level = level
    }
    
    let category: Category
    let level: CategoryLevel
    var isSelected = false
}
enum CategoryLevel {
    case one
    case two
    case three
}
