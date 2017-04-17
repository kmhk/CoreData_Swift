//
//  AddShopViewController.swift
//  ShoppingList
//
//  Created by user on 4/18/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class AddShopViewController: UIViewController {
	
	@IBOutlet weak var txtListName: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func addBtnTapped(_ sender: Any) {
		guard (txtListName.text?.lengthOfBytes(using: .utf8))! > 0 else {
			return
		}
		
		for item in Helper.shared().shops {
			if item.name?.isEqual(txtListName.text) == true {
				let alert = UIAlertController(title: "", message: "It is already existing.", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
				self.present(alert, animated: true, completion: nil)
				return
			}
		}
		
		Helper.shared().addShop(name: txtListName.text!)
		
		self.navigationController?.popViewController(animated: true)
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
