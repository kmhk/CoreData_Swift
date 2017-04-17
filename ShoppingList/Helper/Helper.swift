//
//  Helper.swift
//  ShoppingList
//
//  Created by user on 4/17/17.
//  Copyright © 2017 user. All rights reserved.
//

import UIKit


var gHelper: Helper?

class Helper: NSObject {
	
	// MARK: static members
	static var App = UIApplication.shared.delegate as! AppDelegate
	static var coreData = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	// MARK: public members
	var shoppingItems = [ShoppingItem]()
	
	
	// MARK: - static methods
	static func shared() -> Helper {
		if gHelper == nil {
			gHelper = Helper()
		}
		
		return gHelper!
	}
	
	
	// MARK: - public methods
	func saveCoreData() {
		Helper.App.saveContext()
	}
	
	func getShoppingItems() -> [ShoppingItem] {
		do {
			shoppingItems = try Helper.coreData.fetch(ShoppingItem.fetchRequest())
		} catch {
			print("Fetch core data failed!")
		}
		
		return shoppingItems
	}
	
	func addShoppingItem(name: String) {
		let item = ShoppingItem(context: Helper.coreData)
		item.name = name
		
		// save core data
		self.saveCoreData()
	}
	
	func removeShoppingItem(index: Int) {
		Helper.coreData.delete(shoppingItems[index])
		shoppingItems.remove(at: index)
		
		// save core data
		self.saveCoreData()
	}
	
}
