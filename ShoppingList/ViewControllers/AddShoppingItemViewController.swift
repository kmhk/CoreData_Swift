//
//  AddShoppingItemViewController.swift
//  GottaGet
//
//  Created by user on 4/18/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import CoreData

class AddShoppingItemViewController: UIViewController {

	@IBOutlet weak var lblName: UITextField!
	@IBOutlet weak var lblQuantity: UILabel!
	@IBOutlet weak var tableView: UITableView!
	
	var chosenIndex: Int = 0
	var shopItem: Shop?
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		tableView.delegate = self
		tableView.dataSource = self
		
		lblName.delegate = self
		
//		let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapView))
//		self.view.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func onTapView(_ sender: Any) {
		lblName.resignFirstResponder()
	}
	
	@IBAction func addBtnTapped(_ sender: Any) {
		guard (lblName.text?.lengthOfBytes(using: .utf8))! > 0 else {
			return
		}
		
		let query: NSFetchRequest<Item> = Item.fetchRequest()
		query.predicate = NSPredicate(format: "shop == %@ && category == %@ && name == %@", (shopItem?.name)!, Helper.categories[chosenIndex], lblName.text!)
		
		if let array = try? Helper.coreData.fetch(query) {
			if array.count > 1 {
				print("db error: duplicated item is existing")
				
			} else if array.count == 1 {
				let i = array[0]
				
				i.count += Int64(lblQuantity.text!)!
				Helper.shared().saveCoreData()
				self.navigationController?.popViewController(animated: true)
				return
			}
		}
		
//		for i in Helper.shared().items {
//			if i.shop == shopItem?.name && i.category == Helper.categories[chosenIndex] && i.name == lblName.text {
//				i.count += Int64(lblQuantity.text!)!
//				Helper.shared().saveCoreData()
//				self.navigationController?.popViewController(animated: true)
//				return
//			}
//		}
		
		let item = Item(context: Helper.coreData)
		item.name = lblName.text
		item.count = Int64(lblQuantity.text!)!
		item.category = Helper.categories[chosenIndex]
		item.shop = shopItem?.name
		
		Helper.shared().saveCoreData()
		
		self.navigationController?.popViewController(animated: true)
	}

	@IBAction func onStepper(_ sender: Any) {
		lblQuantity.text = String(describing: Int((sender as! UIStepper).value))
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


// MARK: -
extension AddShoppingItemViewController: UITableViewDelegate, UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Helper.categories.count
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "AddItemTableCell", for: indexPath)
		
		if indexPath.row == chosenIndex {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
		
		cell.textLabel?.text = Helper.categories[indexPath.row]
		
		return cell
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		chosenIndex = indexPath.row
		tableView.reloadData()
	}
}


// MARK: -
extension AddShoppingItemViewController: UITextFieldDelegate {
	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		lblName.resignFirstResponder()
		
		return true
	}
}
