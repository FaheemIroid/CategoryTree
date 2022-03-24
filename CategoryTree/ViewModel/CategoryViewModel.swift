//
//  CategoryViewModel.swift
//  CategoryTree
//
//  Created by Faheem Hussain on 24/03/22.
//

import Foundation
import CoreImage

class CategoryViewModel {
    var itemsDidChange: ((Any?) -> Void)?
    var errorOccured: ((SystemError) -> Void)?
    var categories: [Category] = [] {
        didSet {
            itemsDidChange?(categories)
        }
    }
    static var subUrl: URL?
    //MARK: - Fetch Category List
    func fetchList(completion: @escaping () -> Void) {
        if let url = Bundle.main.url(forResource: "TestCategoryData", withExtension: "json") {
            CategoryViewModel.subUrl = url
            do {
                let data = try Data(contentsOf: url)
                let jsonData = try JSONDecoder().decode(CategoryData.self, from: data)
                self.categories = jsonData.category!
                completion()
            } catch {
                print("error:\(error)")
                self.errorOccured?(error as! SystemError)
                completion()
            }
        }
    }
    func writeToFile(completion: @escaping () -> Void) {
        let cat = CategoryDatas(category: [Categorys(categoryid: 10, categorycode: "10", categoryname: "Faheem", categoryalise: "Fa", imageurl: "", sublist: [])])
        do{
            let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
            let JsonData = try encoder.encode(cat)
            try JsonData.write(to: CategoryViewModel.subUrl!)
            completion()
        }catch{
            print("error:\(error)")
            self.errorOccured?(error as! SystemError)
            completion()
        }
    }
}

struct CategoryDatas : Codable {
    let category : [Categorys]?
}

struct Categorys : Codable {
    let categoryid : Int?
    let categorycode : String?
    let categoryname : String?
    let categoryalise : String?
    let imageurl : String?
    let sublist : [Categorys]?
}
