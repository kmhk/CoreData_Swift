//
//  ShoppingItemTableViewCell.swift
//  GottaGet
//
//  Created by user on 4/18/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class ShoppingItemTableViewCell: UITableViewCell {
	
	static var cellID = "ShoppingItemTableViewCell"
	
	@IBOutlet weak var lblName: UILabel!
	@IBOutlet weak var lblCount: UILabel!
	@IBOutlet weak var stepper: UIStepper!
	

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
