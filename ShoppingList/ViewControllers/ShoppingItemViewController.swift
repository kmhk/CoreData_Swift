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
extension ShoppingItemViewController: UITableViewDelegate, UITableViewDataSource {
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ShopTableViewCell.cellID, for: indexPath) as! ShopTableViewCell
		
		
		
		return cell
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
