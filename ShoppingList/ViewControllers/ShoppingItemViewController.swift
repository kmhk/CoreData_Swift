//
//  ShoppingItemViewController.swift
//  GottaGet
//
//  Created by user on 4/18/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class ShoppingItemViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var viewModel = ShoppingItemViewModel()
	var shopItem: Shop?
	

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		tableView.dataSource = self
		tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		viewModel.getItems(shop: shopItem!)
		tableView.reloadData()
	}
	
	
	func onStepper(_ stepper: UIStepper) {
		let row = stepper.tag % 100
		let section = stepper.tag / 100
		
		let keys = Array(viewModel.items.keys)
		let array = viewModel.items[keys[section]] as! [Any]
		let dict = array[row] as! [String: Any]
		
		viewModel.changeItem(row: row, categoryKey: keys[section], stepper: Int64(stepper.value), purchased: dict["purchased"] as! Bool)
		tableView.reloadData()
	}

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "segueAdd" {
			let vc = segue.destination as! AddShoppingItemViewController
			vc.shopItem = shopItem
		}
    }

}


// MARK: -
extension ShoppingItemViewController: UITableViewDelegate, UITableViewDataSource {
	public func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.items.count
	}
	
	public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let keys = Array(viewModel.items.keys)
		
		return keys[section]
	}
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let keys = Array(viewModel.items.keys)
		let array = viewModel.items[keys[section]] as! [Any]
		
		return array.count
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingItemTableViewCell.cellID, for: indexPath) as! ShoppingItemTableViewCell
		
		let keys = Array(viewModel.items.keys)
		let array = viewModel.items[keys[indexPath.section]] as! [Any]
		let dict = array[indexPath.row] as! [String: Any]
		
		cell.lblName.text = dict["name"] as? String
		
		cell.lblCount.text = String(describing: (dict["count"] as! Int64))
		
		cell.accessoryType = (dict["purchased"] as! Bool == true ? .checkmark : .none)
		
		cell.stepper.addTarget(self, action: #selector(self.onStepper(_:)), for: .valueChanged)
		cell.stepper.tag = indexPath.section * 100 + indexPath.row
		cell.stepper.value = Double(dict["count"] as! Int64)
		
		return cell
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let keys = Array(viewModel.items.keys)
		let array = viewModel.items[keys[indexPath.section]] as! [Any]
		let dict = array[indexPath.row] as! [String: Any]
		
		viewModel.changeItem(row: indexPath.row, categoryKey: keys[indexPath.section], stepper: dict["count"] as! Int64, purchased: !(dict["purchased"] as! Bool))
		tableView.reloadData()
	}
}
