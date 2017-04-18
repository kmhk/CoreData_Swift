//
//  AddShoppingItemViewController.swift
//  GottaGet
//
//  Created by user on 4/18/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class AddShoppingItemViewController: UIViewController {

	@IBOutlet weak var lblName: UITextField!
	@IBOutlet weak var lblQuantity: UILabel!
	@IBOutlet weak var tableView: UITableView!
	
	var chosenIndex: Int = 0
	
	
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
		
		for item in Helper.shared().shops {
			if item.name?.isEqual(lblName.text) == true {
				let alert = UIAlertController(title: "", message: "It is already existing.", preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
				self.present(alert, animated: true, completion: nil)
				return
			}
		}
		
		Helper.shared().addShop(name: lblName.text!)
		
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
