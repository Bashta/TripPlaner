//
//  EditTripViewController.swift
//  Travel Planer
//
//  Created by Alb on 6/9/15.
//  Copyright (c) 2015 01Logic. All rights reserved.
//

import UIKit
import Parse

class EditTripViewController: UIViewController {

	var trip: Trip!

	@IBOutlet weak var destinationTextField: UITextField!
	@IBOutlet weak var startDateTextFiled: UITextField!
	@IBOutlet weak var endDateTextField: UITextField!
	@IBOutlet weak var descriptionTextView: UITextView!

	let dateFormat: NSDateFormatter = NSDateFormatter()
	let datePicker: UIDatePicker = UIDatePicker()

	override func viewDidLoad() {

		dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
		datePicker.datePickerMode = UIDatePickerMode.Date

		datePicker.addTarget(self, action: Selector("updateDateField:"), forControlEvents: UIControlEvents.ValueChanged)

		startDateTextFiled.inputView = datePicker
		endDateTextField.inputView = datePicker

	}



	override func viewWillAppear(animated: Bool) {

		destinationTextField.text = trip.destination
		startDateTextFiled.text = trip.startDate
		endDateTextField.text = trip.endDate
		descriptionTextView.text = trip.comment

	}

	@IBAction func saveTrip(sender: UIBarButtonItem) {

		if(!destinationTextField.text.isEmpty && !startDateTextFiled.text.isEmpty && !endDateTextField.text.isEmpty && !descriptionTextView.text.isEmpty) {

			var query = PFQuery(className:"Posts"); println(trip.objectID)
			query.getObjectInBackgroundWithId(trip.objectID) { (editPost: PFObject?, error: NSError?) -> Void in

				if (error == nil) {

					self.trip.destination = self.destinationTextField.text
					self.trip.startDate = self.startDateTextFiled.text
					self.trip.endDate = self.endDateTextField.text
					self.trip.comment = self.descriptionTextView.text

					self.performSegueWithIdentifier("unwindEdit", sender: self)

				}
			}
		}
	}

	//Selector method calld by the datepicker
	func updateDateField(sender: UIDatePicker) {

		//set the date to the textfield
		if (startDateTextFiled.isFirstResponder()) {

			startDateTextFiled.text = dateFormat.stringFromDate(sender.date)

		} else {

			endDateTextField.text = dateFormat.stringFromDate(sender.date)
			
		}
		
	}
	
}