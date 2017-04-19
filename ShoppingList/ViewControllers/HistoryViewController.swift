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
    
	@IBAction func onRemoveAll(_ sender: Any) {
		let alert = UIAlertController(title: "", message: "Are you sure you want to remove this?", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
		alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
			Helper.shared().removeAllShop();
			self.viewModel.getItems()
			self.tableView.reloadData()
		}))
		
		self.present(alert, animated: true, completion: nil)
	}

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "segueDetail" {
			let vc = segue.destination as! HistoryDetailViewController
			
			let indexPath = sender as! IndexPath
			let keys = Array(viewModel.items.keys)
			let key = keys[indexPath.section]
			let array = viewModel.items[key] as! [Any]
			let dict = array[indexPath.row] as! [String: Any]
			
			vc.item = dict["name"] as? String
			vc.category = key
		}
    }

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
		
		let keys = Array(viewModel.items.keys)
		let array = viewModel.items[keys[indexPath.section]] as! [Any]
		let dict = array[indexPath.row] as! [String: Any]
		
		cell.textLabel?.text = dict["name"] as? String
		
		let lblCount = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
		lblCount.text = String(describing: (dict["count"] as! Int64))
		cell.accessoryView = lblCount
		
		return cell
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		self.performSegue(withIdentifier: "segueDetail", sender: indexPath)
	}
}
