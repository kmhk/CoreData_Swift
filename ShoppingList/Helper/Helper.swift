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
	static var categories = ["Bakery": ["Bread", "Bagels", "Donuts"],
	                         "Fruit & Veg": ["Apples", "Oranges", "Banana"],
	                         "Dairy & Eggs": ["Milk", "Yogurt", "Eggs"],
	                         "Meat, Fish & Poultry": ["Beef", "Salmon", "Chicken"],
	                         "Frozen": ["Ice-Cream", "Frozen Peas", "Fries"],
	                         "Ready meals": ["Pizza", "Sunday Roast", "Stir-Fry"],
	                         "Tins & Jars": ["Jam", "Beans", "Chickpeas"],
	                         "Cereals": ["Cheerios", "Crunchy Nuts", "Honey Loops"],
	                         "Sweets & Snacks": ["Crisps", "Chocolate", "Popcorn"],
	                         "Drinks": ["Juice", "Ice-Tea", "Soda"],
	                         "Household": ["Cleaning spray", "Mop", "Cleaning Cloth"],
	                         "Health & Beauty": ["Shampoo", "Shower Gel", "Soap"]
							]
	
	// MARK: public members
	var shops = [Shop]()
	var items = [Item]()
	var categories = [Category]()
	
	
	// MARK: - static methods
	static func shared() -> Helper {
		if gHelper == nil {
			gHelper = Helper()
		}
		
		let _ = gHelper?.getShopList()
		let _ = gHelper?.getItemList()
		let _ = gHelper?.getCategoryList()
		
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
	
	func removeAllShop() {
		items = self.getItemList()
		
		for i in (0 ..< items.count).reversed() {
			let item = items[i]
			Helper.coreData.delete(item)
			items.remove(at: i)
		}
		
		// save core data
		self.saveCoreData()
	}
	
	func removeShop(index: Int) {
		// remove items
		items = self.getItemList()
		for i in (0 ..< items.count).reversed() {
			let item = items[i]
			if item.name == shops[index].name! {
				Helper.coreData.delete(item)
				items.remove(at: i)
			}
		}
		
		Helper.coreData.delete(shops[index])
		shops.remove(at: index)
		
		// save core data
		self.saveCoreData()
	}
	
	func getCategoryList() -> [Category] {
		repeat {
			do {
				categories = try Helper.coreData.fetch(Category.fetchRequest())
			} catch  {
				print("Fetch Categories from core data failed!")
			}
			
			if categories.count == 0 {
				let array = Array(Helper.categories.keys)
				for item in array {
					self.addCategory(name: item)
				}
			}
			
		} while categories.count == 0
		
		return categories
	}
	
	func addCategory(name: String) {
		let new = Category(context: Helper.coreData)
		new.name = name
		
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
	
	func addItem(name: String, shop: String, category: String, count: Int64, checked: Bool) {
		let item = Item(context: Helper.coreData)
		item.name = name
		item.count = count
		item.category = category
		item.shop = shop
		item.checked = checked
		
		self.saveCoreData()
	}
	
	func removeItem(index: Int) {
		Helper.coreData.delete(items[index])
		items.remove(at: index)
		
		self.saveCoreData()
	}
}
