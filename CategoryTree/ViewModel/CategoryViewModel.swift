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
     func saveDomaines() {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            let fileURL = documentsDirectory.appendingPathComponent("TestCategoryData.js")
            let json = ["category": ["categoryid":"100","categorycode":"100","categoryname":"dsdfsdfsd","categoryalise":"dsafdsfds","imageurl":"","sublist":""]]
            writeFile(fileURL: fileURL, json: json)
        } else {
            print("Shouldn't reach here")
        }
    }
    
     func writeFile(fileURL: URL, json: [String: Any]) {
        do {
            if let jsonData = try JSONSerialization.data(withJSONObject: json, options: .init(rawValue: 0)) as? Data {
                try jsonData.write(to: fileURL)
            }
        } catch {
            print(error.localizedDescription)
        }
    }


}

//struct Categorys : Encodable {
//    let categoryid : Int?
//    let categorycode : String?
//    let categoryname : String?
//    let categoryalise : String?
//    let imageurl : String?
//    let sublist : [Category]?
//}
