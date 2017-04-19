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
	@IBOutlet weak var lblCategory: UITextField!
	@IBOutlet weak var tableView: UITableView!
	
	var chosenIndex: Int = 0
	var shopItem: Shop?
	
	var viewModel = AddShoppingItemViewModel()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		tableView.delegate = self
		tableView.dataSource = self
		tableView.layer.borderWidth = 1.0
		
		lblName.delegate = self
		lblName.tag = 0x100
		lblName.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: .editingChanged)
		
		lblCategory.delegate = self
		lblCategory.tag = 0x101
		lblCategory.addTarget(self, action: #selector(self.textFieldChanged(_:)), for: .editingChanged)
		
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
		guard (lblName.text?.lengthOfBytes(using: .utf8))! > 0 && (lblCategory.text?.lengthOfBytes(using: .utf8))! > 0 else {
			return
		}
		
		// query if shopping item is already existing
		let query: NSFetchRequest<Item> = Item.fetchRequest()
		query.predicate = NSPredicate(format: "shop == %@ && category == %@ && name == %@", (shopItem?.name)!, lblCategory.text!, lblName.text!)
		
		if let array = try? Helper.coreData.fetch(query) {
			if array.count > 1 {
				print("db error: duplicated item is existing")
				return
				
			} else if array.count == 1 {
				let alert = UIAlertController(title: "", message: "It is already added in the shopping items.", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
				self.present(alert, animated: true, completion: nil)
				return
			}
		}
		
		// query if category is new or existing
		let query1: NSFetchRequest<Category> = Category.fetchRequest()
		query1.predicate = NSPredicate(format: "name == %@", lblCategory.text!)
		
		if let array1 = try? Helper.coreData.fetch(query1) {
			if array1.count == 0 { // if new category, add it
				Helper.shared().addCategory(name: lblCategory.text!)
				
			} else if array1.count == 1 {
				print("already existing category")
				
			} else if array1.count > 1 {
				print("db error: duplicated category")
			}
		}
		
		// add new item
		Helper.shared().addItem(name: lblName.text!, shop: (shopItem?.name)!, category: lblCategory.text!, count: 1, checked: false)
		
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


// MARK: -
extension AddShoppingItemViewController: UITableViewDelegate, UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if tableView.tag == 0x100 { // for item name
			if viewModel.items.count == 0 {
				tableView.isHidden = true
			} else {
				tableView.isHidden = false
			}
			return viewModel.items.count
			
		} else { // for category name
			if viewModel.categories.count == 0 {
				tableView.isHidden = true
			} else {
				tableView.isHidden = false
			}
			return viewModel.categories.count
		}
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "AddItemTableCell", for: indexPath)
		
		if tableView.tag == 0x100 { // for item name
			cell.textLabel?.text = viewModel.items[indexPath.row]
			
		} else { // for category name
			cell.textLabel?.text = viewModel.categories[indexPath.row]
		}
		
		return cell
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		if tableView.tag == 0x100 { // for item name
			lblName.text = viewModel.items[indexPath.row]
			
		} else { // for category name
			lblCategory.text = viewModel.categories[indexPath.row]
		}
		
		lblName.resignFirstResponder()
		lblCategory.resignFirstResponder()
	}
}


// MARK: -
extension AddShoppingItemViewController: UITextFieldDelegate {
	public func textFieldChanged(_ textField: UITextField) {
		let key = textField.text!
		
		if textField.tag == 0x100 { // for item name
			lblCategory.text = ""
			let _ = viewModel.getSuggestItemNames(key: key)
		} else {
			let _ = viewModel.getSuggestCategories(key: key, item: lblName.text!)
		}
		tableView.reloadData()
	}
	
	public func textFieldDidBeginEditing(_ textField: UITextField) {
		let frame = textField.frame
		tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y + frame.size.height + 2,
		                         width: frame.size.width, height: 165)
		tableView.isHidden = false
		tableView.tag = textField.tag
		
		if textField.tag == 0x100 { // for item name
			let _ = viewModel.getSuggestItemNames(key: textField.text!)
		} else {
			let _ = viewModel.getSuggestCategories(key: textField.text!, item: lblName.text!)
		}
		tableView.reloadData()
	}
	
	public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		tableView.isHidden = true
		
		return true
	}
	
	public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		
		return true
	}
}
