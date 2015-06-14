//
//  Trips.swift
//  Travel Planer
//
//  Created by Alb on 6/3/15.
//  Copyright (c) 2015 01Logic. All rights reserved.
//

import Foundation

struct Trip {

	var destination: String = ""
	var user: String = ""
	var comment: String = ""
	var startDate: String = ""
	var endDate: String = ""
	var objectID: String = ""

	// Date handling properties
	let dateFormat: NSDateFormatter = NSDateFormatter()
	let datePicker: UIDatePicker = UIDatePicker()

	init() {

		// Date format and date picker setup
		dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
		datePicker.datePickerMode = UIDatePickerMode.Date

	}
	
}