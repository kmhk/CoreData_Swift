//
//  ShopTableViewCell.swift
//  ShoppingList
//
//  Created by user on 4/16/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class ShopTableViewCell: UITableViewCell {
	
	static var cellID = "ShopTableViewCell"
	
	@IBOutlet weak var btnRemove: UIButton!
	@IBOutlet weak var lblName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
