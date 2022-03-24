//
//  CategoryViewModel.swift
//  CategoryTree
//
//  Created by Faheem Hussain on 24/03/22.
//

import Foundation

class CategoryViewModel {
    var itemsDidChange: ((Any?) -> Void)?
    var errorOccured: ((SystemError) -> Void)?
    var categories: [Category] = [] {
        didSet {
            itemsDidChange?(categories)
        }
    }
    //MARK: - Fetch Category List
    func fetchList(completion: @escaping () -> Void) {
        if let url = Bundle.main.url(forResource: "TestCategoryData", withExtension: "js") {
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
    
    func writeJSON(completion: @escaping () -> Void) {
        let category = AddCategoryParams(categoryid: 10, categorycode: "10", categoryname: "test data", categoryalise: "test", imageurl: "https://i.imgur.com/zjekjLY.jpeg", sublist: nil)
        //var array : CategoryDatas!
       // array.category?.append(category)

        do {
            let fileURL = try FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("TestCategoryData.js")

            let encoder = JSONEncoder()
            try encoder.encode(category).write(to: fileURL)
            completion()
        } catch {
            print(error.localizedDescription)
            completion()
        }
    }
}

struct CategoryDatas : Encodable {
    var category : [AddCategoryParams]?
}
struct AddCategoryParams: Encodable {
    var categoryid : Int?
    var categorycode : String?
    var categoryname : String?
    var categoryalise : String?
    var imageurl : String?
    var sublist : [AddCategoryParams]?
}
