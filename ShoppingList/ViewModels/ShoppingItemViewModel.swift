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
	var curShop: Shop?
	
	override init() {
		super.init()
	}
	
	func getItems(shop: Shop) {
		items.removeAll()
		
		curShop = shop
		
		let query: NSFetchRequest<Item> = Item.fetchRequest()
		query.predicate = NSPredicate(format: "shop == %@", shop.name!)
		
		let all = try? Helper.coreData.fetch(query)
		for item in all! {
			let dict = ["name": item.name!,
			            "count": item.count,
			            "purchased": item.checked] as [String : Any]
			
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
	
	func changeItem(row: Int, categoryKey: String, stepper: Int64, purchased: Bool) {
		let array = items[categoryKey] as! [Any]
		let dict = array[row] as! [String: Any]
		
		let query: NSFetchRequest<Item> = Item.fetchRequest()
		query.predicate = NSPredicate(format: "shop == %@ && category == %@ && name == %@", (curShop?.name!)!, categoryKey, dict["name"]! as! CVarArg)
		
		let all = try? Helper.coreData.fetch(query)
		if (all?.count)! > 1 || (all?.count)! == 0 {
			print("db error: can't change value of the shopping item!")
			return
		}
		
		all?.first?.count = stepper
		all?.first?.checked = purchased
		
		Helper.shared().saveCoreData()
		
		self.getItems(shop: curShop!)
	}
}
