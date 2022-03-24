//
//  ViewController.swift
//  CategoryTree
//
//  Created by Faheem Hussain on 24/03/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tvList: UITableView!
    
    private var viewModel = CategoryViewModel()
    private var items: [CategoryCellItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setListner()
        self.refreshData()
    }
//MARK: - Listner
    func setListner(){
        viewModel.itemsDidChange = { [weak self] _ in
            self?.setItems()
        }
        viewModel.errorOccured = { [weak self] error in
            self?.showAlertAction(title: "Category Tree", message: "Data not in correct formate")
        }
    }
    
    func setItems() {
        let categories = viewModel.categories
        items = categories.map({ CategoryCellItem(category: $0, level: .one) })
            DispatchQueue.main.async {
                self.tvList.reloadData()
            }
    }
//MARK: - Fetch Data
    func refreshData() {
        viewModel.fetchList {
        }
    }
    func findResultForCategory(levelOne: CategoryCellItem?, levelTwo: CategoryCellItem?, levelThree: CategoryCellItem?) {
        self.performSegue(withIdentifier: "CategoryDetails", sender: levelOne ?? levelTwo ?? levelThree)
    }
    //MARK: - Tree Logic
    func setItemAsSelected(_ item: CategoryCellItem, index: Int) {
        guard item.level != .three else {
            findResultForCategory(levelOne: nil, levelTwo: nil, levelThree: item)
            return
        }
        
        func removeTwoAndThree() {
            self.items.removeAll(where: { $0.level == .two || $0.level == .three })
        }
        
        func removeThree() {
            self.items.removeAll(where: { $0.level == .three })
        }
        
        func revokeAllSelection() {
            self.items.forEach({ $0.isSelected = false })
        }
        if item.isSelected {
            item.isSelected = false
            switch item.level {
            case .one:
                removeTwoAndThree()
            case .two:
                removeThree()
            default:
                break
            }
        } else {
            switch item.level {
            case .one:
                removeTwoAndThree()
                revokeAllSelection()
                item.isSelected = true
                
                if let sublist = item.category.sublist {
                    let levelTwoItems = sublist.map({ CategoryCellItem(category: $0, level: .two) })
                    if let index = self.items.firstIndex(where: { $0.category.categoryid == item.category.categoryid && item.level == .one }) {
                        self.items.insert(contentsOf: levelTwoItems, at: index + 1)
                    }
                } else {
                    findResultForCategory(levelOne: item, levelTwo: nil, levelThree: nil)
                }
            case .two:
                item.isSelected = true
                if let sublist = item.category.sublist {
                   let levelTwoItems = sublist.map({ CategoryCellItem(category: $0, level: .three) })
                   self.items.insert(contentsOf: levelTwoItems, at: index + 1)
                } else {
                    findResultForCategory(levelOne: nil, levelTwo: item, levelThree: nil)
                }
            default:
                break
            }
        }
        DispatchQueue.main.async {
            self.tvList.reloadData()
        }
    }
}
//MARK: - Message Box
extension ViewController {
    func showAlertAction(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            print("Action")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    //MARK: - Button Action
    @IBAction func addCategoryButtonClicked(_ sender: Any) {
        viewModel.writeToFile{
            self.refreshData()
        }
    }
    
}
//MARK: - Table DataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: CategoryListTVCell
        let item = items[indexPath.row]
        switch item.level {
        case .one:
            cell = tableView.dequeueReusableCell(withIdentifier: CategoryListTVCell.levelOneId) as! CategoryListTVCell
        case .two:
            cell = tableView.dequeueReusableCell(withIdentifier: CategoryListTVCell.levelTwoId) as! CategoryListTVCell
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: CategoryListTVCell.levelThreeId) as! CategoryListTVCell
        }
        cell.set(item: item)
        return cell
    }
}
//MARK: - Table Delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setItemAsSelected(items[indexPath.row], index: indexPath.row)
    }
}
