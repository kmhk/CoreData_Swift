//
//  ShoppingItemViewModel.swift
//  GottaGet
//
//  Created by user on 4/18/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import CoreData


class ShoppingItemViewModel: NSObject {
	var items = [String: Any]()
	
	override init() {
		super.init()
	}
	
	func getItems(shop: Shop) {
		items.removeAll()
		
		let query: NSFetchRequest<Item> = Item.fetchRequest()
		query.predicate = NSPredicate(format: "shop == %@", shop.name!)
		
		let all = try? Helper.coreData.fetch(query)
		for item in all! {
			let dict = ["name": item.name!,
			            "count": item.count] as [String : Any]
			
			if let subs = items[item.category!] {
				var tmps = subs as! [Any]
				tmps.append(dict)
				
				items[item.category!] = tmps
				
			} else {
				var tmps = [Any]()
				tmps.append(dict)
				
				items[item.category!] = tmps
			}
		}
	}
}
