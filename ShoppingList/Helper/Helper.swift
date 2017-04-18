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
	static var categories = ["Bakery",
	                         "Fruit & Veg",
	                         "Dairy & Eggs",
	                         "Meat, Fish & Poultry",
	                         "Frozen",
	                         "Ready meals",
	                         "Tins & Jars",
	                         "Cereals",
	                         "Sweets & Snacks",
	                         "Drinks",
	                         "Household",
	                         "Health & Beauty"]
	
	// MARK: public members
	var shops = [Shop]()
	var items = [Item]()
	
	
	// MARK: - static methods
	static func shared() -> Helper {
		if gHelper == nil {
			gHelper = Helper()
		}
		
		let _ = gHelper?.getShopList()
		let _ = gHelper?.getItemList()
		
		return gHelper!
	}
	
	
	// MARK: - public methods
	func saveCoreData() {
		Helper.App.saveContext()
	}
	
	func getShopList() -> [Shop] {
		do {
			shops = try Helper.coreData.fetch(Shop.fetchRequest())
		} catch {
			print("Fetch shops core data failed!")
		}
		
		return shops
	}
	
	func addShop(name: String) {
		let item = Shop(context: Helper.coreData)
		item.name = name
		
		// save core data
		self.saveCoreData()
	}
	
	func removeShop(index: Int) {
		Helper.coreData.delete(shops[index])
		shops.remove(at: index)
		
		// save core data
		self.saveCoreData()
	}
	
	func getItemList() -> [Item] {
		do {
			items = try Helper.coreData.fetch(Item.fetchRequest())
		} catch {
			print("Fetch items from core data failed!")
		}
		
		return items
	}
	
	func removeItem(index: Int) {
		Helper.coreData.delete(items[index])
		items.remove(at: index)
		
		self.saveCoreData()
	}
}
