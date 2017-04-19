//
//  HistoryDetailViewModel.swift
//  GottaGet
//
//  Created by user on 4/19/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import CoreData


class HistoryDetailViewModel: NSObject {

	var items = [String: Any]()
	
	
	func getItems(item: String, category: String) {
		items.removeAll()
		
		let query: NSFetchRequest<Item> = Item.fetchRequest()
		query.predicate = NSPredicate(format: "category == %@ && name == %@ && checked == %@", category, item, NSNumber(value: true))
		
		let all = try? Helper.coreData.fetch(query)
		for item in all! {
			let dict = ["name": item.name!,
			            "count": item.count] as [String: Any]
			
			items[item.shop!] = dict
		}
	}
}
