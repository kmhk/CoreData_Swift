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
		cell.accessoryType = .checkmark
		
		let keys = Array(viewModel.items.keys)
		let array = viewModel.items[keys[indexPath.section]] as! [Any]
		let dict = array[indexPath.row] as! [String: Any]
		
		cell.lblName.text = dict["name"] as? String
		cell.lblCount.text = String(describing: (dict["count"] as! Int64))
		
		return cell
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
