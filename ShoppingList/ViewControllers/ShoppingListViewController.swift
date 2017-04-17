//
//  ShoppingListViewController.swift
//  ShoppingList
//
//  Created by user on 4/16/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController {
	
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
		let _ = Helper.shared().getShoppingItems()
		
		tableView.reloadData()
	}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

	
	// MARK: - button action implementations
	func onRemoveShoppingList(_ sender: Any) {
		let index = (sender as AnyObject).tag
		
		Helper.shared().removeShoppingItem(index: index!)
		
		tableView.reloadData()
	}
}


// MARK: -
extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Helper.shared().shoppingItems.count
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingTableViewCell.cellID, for: indexPath) as! ShoppingTableViewCell
		
		cell.btnRemove.addTarget(self, action: #selector(self.onRemoveShoppingList(_:)), for: .touchUpInside)
		cell.btnRemove.tag = indexPath.row
		
		cell.lblName.text = Helper.shared().shoppingItems[indexPath.row].name
		
		return cell
	}
}
