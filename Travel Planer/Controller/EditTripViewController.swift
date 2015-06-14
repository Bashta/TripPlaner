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

	// MARK: Properties

	// Trip object used to save the Trip to be added by the user
	var trip: Trip = Trip()

	// Input fields for the user
	@IBOutlet weak var destinationTextField: UITextField!
	@IBOutlet weak var startDateTextFiled: UITextField!
	@IBOutlet weak var endDateTextField: UITextField!
	@IBOutlet weak var descriptionTextView: UITextView!

   // MARK: Methods

	override func viewDidLoad() {

		// Add the event for the datepicker when the value is changed
		trip.datePicker.addTarget(self, action: Selector("updateDateField:"), forControlEvents: UIControlEvents.ValueChanged)

		// Add the date picker as input view to the date text fields
		startDateTextFiled.inputView = trip.datePicker
		endDateTextField.inputView = trip.datePicker

	}

	override func viewWillAppear(animated: Bool) {

		// Populate the input fields with values from the selected row.
		destinationTextField.text = trip.destination
		startDateTextFiled.text = trip.startDate
		endDateTextField.text = trip.endDate
		descriptionTextView.text = trip.comment

	}

	@IBAction func saveTrip(sender: UIBarButtonItem) {

		if(!destinationTextField.text.isEmpty && !startDateTextFiled.text.isEmpty && !endDateTextField.text.isEmpty && !descriptionTextView.text.isEmpty) {

			// Querry the Posts table for our object and updating it
			var query = PFQuery(className:"Posts")
			query.getObjectInBackgroundWithId(trip.objectID) { (editPost: PFObject?, error: NSError?) -> Void in

				if (error == nil) {

					self.trip.destination = self.destinationTextField.text
					self.trip.startDate = self.startDateTextFiled.text
					self.trip.endDate = self.endDateTextField.text
					self.trip.comment = self.descriptionTextView.text

					self.performSegueWithIdentifier("unwindEdit", sender: self)

				} else {

					//Report the user that an error has occured
					var errorMessage = error!.userInfo!["error"] as! String
					let alertView = UIAlertView(title: "Error", message: errorMessage, delegate: self, cancelButtonTitle: "Ok")
					alertView.alertViewStyle = UIAlertViewStyle.Default
					alertView.show()

				}
			}
		}
	}

	// Selector method calld by the datepicker
	func updateDateField(sender: UIDatePicker) {

		// Set the date to the textfield
		if (startDateTextFiled.isFirstResponder()) {

			startDateTextFiled.text = trip.dateFormat.stringFromDate(sender.date)

		} else {

			endDateTextField.text = trip.dateFormat.stringFromDate(sender.date)
			
		}
	}
	
}