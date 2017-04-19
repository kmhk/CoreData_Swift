//
//  ShopViewController.swift
//  ShoppingList
//
//  Created by user on 4/18/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		tableView.delegate = self
		tableView.dataSource = self
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		getData()
	}
	
	
	// MARK: - private methods
	private func getData() {
		let _ = Helper.shared().getShopList()
		
		tableView.reloadData()
	}
	

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "segueItem" {
			let vc = segue.destination as! ShoppingItemViewController
			vc.shopItem = Helper.shared().shops[(sender as! IndexPath).row]
		}
    }

	
	// MARK: - button action implementations
	func onRemoveShop(_ sender: Any) {
		let index = (sender as AnyObject).tag
		
		let alert = UIAlertController(title: "", message: "Are you sure you want to remove this?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
		alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
			Helper.shared().removeShop(index: index!)
			self.tableView.reloadData()
		}))
		
		self.present(alert, animated: true, completion: nil)
	}

}


// MARK: -
extension ShopViewController: UITableViewDelegate, UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Helper.shared().shops.count
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ShopTableViewCell.cellID, for: indexPath) as! ShopTableViewCell
		
		cell.accessoryType = .disclosureIndicator
		
		cell.btnRemove.addTarget(self, action: #selector(self.onRemoveShop(_:)), for: .touchUpInside)
		cell.btnRemove.tag = indexPath.row
		
		cell.lblName.text = Helper.shared().shops[indexPath.row].name
		
		return cell
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		self.performSegue(withIdentifier: "segueItem", sender: indexPath)
	}
}
