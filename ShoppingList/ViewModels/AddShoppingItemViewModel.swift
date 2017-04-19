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
	var categories = [String]()
	var items = [String]()
	
	
	override init() {
		super.init()
	}
	
	
	func categoriesOf(item: String) -> [String] {
		var result = [String]()
		Helper.categories.enumerated().forEach { (offset, element) -> () in
			let array = element.value.filter({ (i) -> Bool in
				return (item == "" || i == item)
			})
			
			if array.count > 0 {
				result.append(element.key)
			}
		}
		
		let req: NSFetchRequest<Item> = Item.fetchRequest()
		if item != "" {
			req.predicate = NSPredicate(format: "name == %@", item)
		}
		
		let array = try? Helper.coreData.fetch(req).sorted(by: {$0.0.name! < $0.1.name!})
		array?.enumerated().forEach { (i) -> () in
			if result.contains(i.element.category!) == false {
				result.append(i.element.category!)
			}
		}
		
		return result
	}
	
	
	func getSuggestCategories(key: String, item: String) -> [String] {
		categories.removeAll()
		
		var array = categoriesOf(item: item)
		if array.count == 0 {
			let tmps = try? Helper.coreData.fetch(Category.fetchRequest()).sorted(by: {$0.0.name! < $0.1.name!})
			tmps?.enumerated().forEach { (i) -> () in
				array.append(i.element.name!)
			}
		}
		
		categories = array.filter { (i) -> Bool in
			return (key == "" || i.uppercased().contains(key.uppercased()))
		}
		
		return categories
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
			if items.contains(i.element.name!) == false {
				items.append(i.element.name!)
			}
		}
		
		return items
	}
}
