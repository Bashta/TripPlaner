//
//  Helpers.swift
//  Travel Planer
//
//  Created by Alb on 6/14/15.
//  Copyright (c) 2015 01Logic. All rights reserved.
//

// MARK: - Heper extensions

// String extension to veryfy if a strin is a valid email adress. Not written by me. The solution was fount on Stack Overflow.
//Should be probably be moved in another class(new class or in the Sing in class where its actually used)
extension String {
	func isEmail() -> Bool {

		let regularExpresion = NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: .CaseInsensitive, error: nil)
		return regularExpresion?.firstMatchInString(self, options: nil, range: NSMakeRange(0, count(self))) != nil
	}
}

//String extension to get the lenght of a string
extension String {

	var length: Int { return count(self)  }

}

//Array extension to get the elemnt at index if it exists. returns null if !true
extension Array {
	func get (index: Int) -> Element? {

		return index >= 0 && index < count ? self[index] : nil
		
	}
}
