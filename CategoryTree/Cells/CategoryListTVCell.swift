//
//  CategoryListTVCell.swift
//  VFECommerce
//
//  Created by Faheem Hussain on 24/03/22.
//


import UIKit
import SDWebImage

class CategoryListTVCell: UITableViewCell {
    static let levelOneId = "CategoryListTVCell"
    static let levelTwoId = "CategoryLevelTwoListTVCell"
    static let levelThreeId = "CategoryLevelThreeListTVCell"
    
    @IBOutlet weak var ivImage: UIImageView?
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel?
    @IBOutlet weak var ivSelectionIndicator: UIImageView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func set(item: CategoryCellItem) {
        lblName.text = item.category.categoryname
        lblDescription?.text = item.category.categoryalise
        let fileUrl = URL(string: item.category.imageurl!)
        ivImage?.sd_setImage(with: fileUrl, placeholderImage: .imagePlaceholder)
        ivSelectionIndicator?.image = UIImage(named: item.isSelected ? "ic.arrow.up" : "ic.arrow.down")
    }
}

extension UIImage {
    static var imagePlaceholder: UIImage? {
        UIImage(named: "ic.placeholder.image")
    }
}
