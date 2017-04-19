//
//  AddShoppingItemViewModel.swift
//  GottaGet
//
//  Created by user on 4/19/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit
import CoreData


class AddShoppingItemViewModel: NSObject {
	var categories: [Category]?
	var items = [String]()
	
	
	override init() {
		super.init()
	}
	
	
	func getSuggestCategories(key: String) -> [Category] {
		let req: NSFetchRequest<Category> = Category.fetchRequest()
		
		if key != "" {
			req.predicate = NSPredicate(format: "name CONTAINS[cd] %@", key)
		}
		
		let array = try? Helper.coreData.fetch(req)
		categories = array?.sorted(by: {$0.0.name! < $0.1.name!})
		
		return categories!
	}
	
	
	func getSuggestItemNames(key: String) -> [String] {
		items.removeAll()
		
		Helper.categories.enumerated().forEach { (i) -> () in
			i.element.value.enumerated().forEach { (j) -> () in
				if key == "" || j.element.contains(key) == true {
					items.append(j.element)
				}
			}
		}
		
		let req: NSFetchRequest<Item> = Item.fetchRequest()
		
		if key != "" {
			req.predicate = NSPredicate(format: "name CONTAINS[cd] %@", key)
		}
		
		let array = try? Helper.coreData.fetch(req).sorted(by: {$0.0.name! < $0.1.name!})
		array?.enumerated().forEach { (i) -> () in
			items.append(i.element.name!)
		}
		
		return items
	}
}
