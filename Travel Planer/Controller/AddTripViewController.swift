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

	var trip: Trip = Trip()

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

	@IBAction func saveTrip(sender: UIBarButtonItem) {

		if(!destinationTextField.text.isEmpty && !startDateTextFiled.text.isEmpty && !endDateTextField.text.isEmpty && !descriptionTextView.text.isEmpty) {

			trip.user = PFUser.currentUser()!.username!
			trip.destination = destinationTextField.text
			trip.startDate = startDateTextFiled.text
			trip.endDate = endDateTextField.text
			trip.comment = descriptionTextView.text

			self.performSegueWithIdentifier("unwind", sender: self)

		} else {

			let alertView = UIAlertView(title: "Incloplete Information", message: "Please fill in all the fileds", delegate: self, cancelButtonTitle: "Ok")
			alertView.alertViewStyle = UIAlertViewStyle.Default
			alertView.show()
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












