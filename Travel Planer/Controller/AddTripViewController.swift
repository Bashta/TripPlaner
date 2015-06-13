//
//  AddTripViewController.swift
//  Travel Planer
//
//  Created by Alb on 6/5/15.
//  Copyright (c) 2015 01Logic. All rights reserved.
//

import UIKit
import Parse

class AddTripViewController: UIViewController {

	// MARK: Properties

	// Trip object used to save the Trip to be added by the user
	var trip: Trip = Trip()

	// Input fields for the user
	@IBOutlet weak var destinationTextField: UITextField!
	@IBOutlet weak var startDateTextFiled: UITextField!
	@IBOutlet weak var endDateTextField: UITextField!
	@IBOutlet weak var descriptionTextView: UITextView!

	// Date handling properties
	let dateFormat: NSDateFormatter = NSDateFormatter()
	let datePicker: UIDatePicker = UIDatePicker()


	// MARK: Methods

	override func viewDidLoad() {

		// Date format and date picker setup
		dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle
		datePicker.datePickerMode = UIDatePickerMode.Date

		// Add the event for the datepicker when the value is changed
		datePicker.addTarget(self, action: Selector("updateDateField:"), forControlEvents: UIControlEvents.ValueChanged)

		// Add the date picker as input view to the date text fields
		startDateTextFiled.inputView = datePicker
		endDateTextField.inputView = datePicker
	}

	@IBAction func saveTrip(sender: UIBarButtonItem) {

		if(!destinationTextField.text.isEmpty && !startDateTextFiled.text.isEmpty && !endDateTextField.text.isEmpty && !descriptionTextView.text.isEmpty) {

			// Update our local trip object with the information gathered from the user
			trip.user = PFUser.currentUser()!.username!
			trip.destination = destinationTextField.text
			trip.startDate = startDateTextFiled.text
			trip.endDate = endDateTextField.text
			trip.comment = descriptionTextView.text

			// Dismiss the view
			self.performSegueWithIdentifier("unwind", sender: self)

		} else {

			// Inform the user that all fields are required
			let alertView = UIAlertView(title: "Incloplete Information", message: "Please fill in all the fileds", delegate: self, cancelButtonTitle: "Ok")
			alertView.alertViewStyle = UIAlertViewStyle.Default
			alertView.show()
		}
	}

	// Selector method calld by the datepicker
	func updateDateField(sender: UIDatePicker) {

		// Set the date to the textfield
		if (startDateTextFiled.isFirstResponder()) {

			startDateTextFiled.text = dateFormat.stringFromDate(sender.date)

		} else {

			endDateTextField.text = dateFormat.stringFromDate(sender.date)

		}
	}
	
}












