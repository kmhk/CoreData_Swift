//
//  HistoryViewController.swift
//  ShoppingList
//
//  Created by user on 4/16/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var viewModel = HistoryViewModel()

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
		
		viewModel.getItems()
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

}


// MARK: -
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
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
		let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath)
		cell.accessoryType = .checkmark
		
		let keys = Array(viewModel.items.keys)
		let array = viewModel.items[keys[indexPath.section]] as! [Any]
		let dict = array[indexPath.row] as! [String: Any]
		
		cell.textLabel?.text = dict["name"] as? String
		
		return cell
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
