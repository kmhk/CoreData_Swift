//
//  HistoryViewModel.swift
//  GottaGet
//
//  Created by user on 4/18/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import CoreData

class HistoryViewModel: NSObject {
	
	var items = [String: Any]()
	
	
	override init() {
		super.init()
	}
	
	
	func addItem(tmps: [Any], dict:[String: Any]) -> [Any] {
		var array = tmps as! [[String: Any]]

		for i in 0..<array.count {
			var item = array[i]
			
			if (item["name"] as! String) == (dict["name"] as! String) {
				item["count"] = (item["count"] as! Int64) + (dict["count"] as! Int64)
				array[i] = item
				
				return array
			}
		}
		
		array.append(dict)
		return array
	}
	
	
	func getItems() {
		items.removeAll()
		
		let query: NSFetchRequest<Item> = Item.fetchRequest()
		query.predicate = NSPredicate(format: "checked == %@", NSNumber(value: true))
		
		let all = try? Helper.coreData.fetch(query)
		for item in all! {
			let dict = ["name": item.name!,
			            "count": item.count] as [String: Any]
			
			if let subs = items[item.category!] {
				let tmps = subs as! [Any]
				
				items[item.category!] = addItem(tmps: tmps, dict: dict)
				
			} else {
				var tmps = [Any]()
				tmps.append(dict)
				
				items[item.category!] = tmps
			}
		}
	}
	
}
