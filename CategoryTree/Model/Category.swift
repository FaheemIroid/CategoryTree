//
//  Category.swift
//  CategoryTree
//
//  Created by Faheem Hussain on 24/03/22.
//

import Foundation

struct CategoryData : Codable {
    let category : [Category]?
    enum CodingKeys: String, CodingKey {

        case category = "category"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        category = try values.decodeIfPresent([Category].self, forKey: .category)
    }
}


struct Category : Codable {
    let categoryid : Int?
    let categorycode : String?
    let categoryname : String?
    let categoryalise : String?
    let imageurl : String?
    let sublist : [Category]?

    enum CodingKeys: String, CodingKey {

        case categoryid = "categoryid"
        case categorycode = "categorycode"
        case categoryname = "categoryname"
        case categoryalise = "categoryalise"
        case imageurl = "imageurl"
        case sublist = "sublist"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categoryid = try values.decodeIfPresent(Int.self, forKey: .categoryid)
        categorycode = try values.decodeIfPresent(String.self, forKey: .categorycode)
        categoryname = try values.decodeIfPresent(String.self, forKey: .categoryname)
        categoryalise = try values.decodeIfPresent(String.self, forKey: .categoryalise)
        imageurl = try values.decodeIfPresent(String.self, forKey: .imageurl)
        sublist = try values.decodeIfPresent([Category].self, forKey: .sublist)
    }

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
