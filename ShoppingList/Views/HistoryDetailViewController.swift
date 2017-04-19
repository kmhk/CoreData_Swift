//
//  HistoryDetailViewController.swift
//  GottaGet
//
//  Created by user on 4/19/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit

class HistoryDetailViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	var viewModel = HistoryDetailViewModel()
	var item: String?
	var category: String?
	

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
		
		self.navigationItem.title = "History of " + item!
		
		viewModel.getItems(item: item!, category: category!)
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
extension HistoryDetailViewController: UITableViewDelegate, UITableViewDataSource {
	public func numberOfSections(in tableView: UITableView) -> Int {
		return viewModel.items.count
	}
	
	public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let keys = Array(viewModel.items.keys)
		
		return keys[section]
	}
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath)
		
		let keys = Array(viewModel.items.keys)
		let key = keys[indexPath.section]
		let dict = viewModel.items[key] as! [String: Any]
		
		cell.textLabel?.text = dict["name"] as? String
		
		let lblCount = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
		lblCount.text = String(describing: (dict["count"] as! Int64))
		cell.accessoryView = lblCount
		
		return cell
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
	}
}
