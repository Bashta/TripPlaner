//
//  ViewController.swift
//  Travel Planer
//
//  Created by Alb on 6/3/15.
//  Copyright (c) 2015 01Logic. All rights reserved.
//

import UIKit
import Parse

// MARK: - Class
class ViewController: UITableViewController, LogInViewControllerDelegate, SignUpViewControllerDelegate {

	// MARK: Properties

	//Array that sevaes PFObjects to be shown or retrived form the database
	var tripObjects: [Trip] = []

	//Object that encapsulate a Trip
	var tripPost: Trip!

	//Object to pass to the edit view
	var editTrip: Trip!

	//NSCaledear
	var calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!

	override func viewDidLoad() {

		super.viewDidLoad()
	}

	override func viewDidAppear(animated: Bool) {

		//Check if there is already a user signed in
		if (PFUser.currentUser() == nil) {
			let popin = LogInViewController(nibName: "LogInView", bundle:nil)
			popin.delegate = self
			self.presentPopinController(popin, animated: true, completion: nil)
		}
	}

	override func viewWillAppear(animated: Bool) {

		//make sure we have a user loged in before fetching data from the local database
		if( PFUser.currentUser() != nil) {

			fetchObjectsFromParseDatabase()

		}
	}

	// MARK: - LogIn Delegate Methods

	func onRegisterButtonPressed(loginViewController : LogInViewController) {

		//Dismiss the LogIn view and presnt the SignUp
		self.dismissCurrentPopinControllerAnimated(true, completion: {
			() -> Void in

			let popin = SignUpViewController(nibName:"SignUpView", bundle:nil)
			popin.delegate = self
			self.presentPopinController(popin, animated: true, completion: nil)

		})

	}

	func onLogInButtonPressed(loginViewController: LogInViewController) {

		//Dismiss the view after a successfull log in was handled by the log in VC
		self.dismissCurrentPopinControllerAnimated(true, completion: nil)

		// Update the view after log in
		self.fetchObjectsFromLocalDatabase()
		self.fetchObjectsFromParseDatabase()
	}

	func onSignUpButtonPressed(signUpViewController: SignUpViewController) {

		//Dismiss the view after a successfull log in was handled by the sign up VC
		self.dismissCurrentPopinControllerAnimated(true, completion: nil)

		//Update the tableviw data that might have been there from another user
		fetchObjectsFromParseDatabase() // in case the
	}

	func onSignUpWithFacebookButtonPressed(signUpViewController: SignUpViewController) {

		//To be implemented

	}

	func onFacebookLoginButtonPressed(loginViewController: LogInViewController) {

		//To be implemented

	}

	// MARK: - Controller Methods

	func fetchObjectsFromLocalDatabase() {

		//Set up a querry for the objects saved localy (pined)
		var querry: PFQuery = PFQuery(className: "Posts")
		querry.fromLocalDatastore().whereKey("username", equalTo: PFUser.currentUser()!.username!)
		querry.findObjectsInBackgroundWithBlock { (objects, error) -> Void in

			if(error == nil) {

				//Save the objects in our property
				self.tripObjects = self.saveQuerryObjects(objects)!

				self.tableView.reloadData()

			} else {

				//Report the user that an error has occured
				var errorMessage = error!.userInfo!["error"] as! String
				let alertView = UIAlertView(title: "Error", message: errorMessage, delegate: self, cancelButtonTitle: "Ok")
				alertView.alertViewStyle = UIAlertViewStyle.Default
				alertView.show()
			}
		}
	}

	func fetchObjectsFromParseDatabase() {

		//Clear all the pins before querring the server
		PFObject.unpinAllObjectsInBackgroundWithBlock(nil)

		//Set up a querry for the objects saved on the server (pined)
		var querry: PFQuery = PFQuery(className: "Posts")
		querry.whereKey("username", equalTo: PFUser.currentUser()!.username!)
		querry.findObjectsInBackgroundWithBlock { (objects, error) -> Void in

			if(error == nil) {

				//Save the objects in our property, refresh our table view, save the objects to the local database.
				self.tripObjects = self.saveQuerryObjects(objects)!

				self.tableView.reloadData()

				PFObject.pinAllInBackground(objects)

			} else {

				//Report the user that an error has occured
				var errorMessage = error!.userInfo!["error"] as! String
				let alertView = UIAlertView(title: "Error", message: errorMessage, delegate: self, cancelButtonTitle: "Ok")
				alertView.alertViewStyle = UIAlertViewStyle.Default
				alertView.show()

			}
		}
	}


	@IBAction func logOut(sender: UIBarButtonItem) {

		//Log out the current user
		PFUser.logOut()

		//Present the log in view
		let popin = LogInViewController(nibName: "LogInView", bundle:nil)
		popin.delegate = self
		self.presentPopinController(popin, animated: true, completion: nil)

	}

	// MARK: - Table View DataSource Methods

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

		return 1

	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

		return self.tripObjects.count

	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

		let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MainTableViewCell

		//Date setup to manage the day ledt label
		let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)

		let dateFormatter = NSDateFormatter()
		dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle

		let now = NSDate()
		let startDate = dateFormatter.dateFromString(tripObjects[indexPath.row].startDate)

		//Set the hour to 00:00 in order to get the days difference, otherwise a 23 hours dif its considered 0 days. ( a more human way of thinking about days than machines :P )
		let date1 = calendar!.startOfDayForDate(now)
		let date2 = calendar!.startOfDayForDate(startDate!)

		let flags = NSCalendarUnit.CalendarUnitDay
		let daysDiference = calendar!.components(flags, fromDate: date1, toDate: date2, options: nil)

		//Show days to trips in case there is a diff, else hide them 
		if (daysDiference.day > 0) {

			cell.daysLabel.text = String(daysDiference.day)

		} else {

			cell.daysLabel.hidden = true
			cell.daysToStartLabel.hidden = true
		}

		// Update the Cells
			cell.descriptionTextView.text = tripObjects[indexPath.row].comment
			cell.stardDateLabel.text = tripObjects[indexPath.row].startDate
			cell.endDateLabel.text = tripObjects[indexPath.row].endDate
			cell.destinationLabel.text = tripObjects[indexPath.row].destination

      return cell

	}

	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

		//Implement the delete func from the row
		switch editingStyle {

		case .Delete:

			//Remove the object from the model,remove the the view, remove form the parse databese
			self.deleteobjectFromDatabase(tripObjects[indexPath.row].objectID)
			self.tripObjects.removeAtIndex(indexPath.row)
			self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)

		default:
			return
		}

	}

	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

		//Set the editTrip property to be passed to the EditTripViewController for editing
		editTrip = Trip()
		editTrip = tripObjects[indexPath.row]
		performSegueWithIdentifier("ToEditTrip", sender: self)

	}
	/*
	Using Unwind Segues
	Unwind segues give you a way to "unwind" the navigation stack back through push, modal, popover, and other types of segues. You use unwind segues to "go back" one or more steps in your navigation hierarchy. Unlike a normal segue, which create a new instance of their destination view controller and transitions to it, an unwind segue transitions to an existing view controller in your navigation hierarchy. Callbacks are provided to both the source and destination view controller before the transition begins. You can use these callbacks to pass data between the view controllers.
	*/

	@IBAction func unwindToMainViewFromAddTrip(sender: UIStoryboardSegue) {


		let sourceViewController: AddTripViewController = sender.sourceViewController as! AddTripViewController
		self.tripPost = sourceViewController.trip

		if(tripPost != nil) {

			//Retrive the object from the AddTripViewController and add it to a post Object
			var newPost = PFObject(className: "Posts")
			newPost["username"] = tripPost.user
			newPost["destination"] = tripPost.destination
			newPost["startDate"] = tripPost.startDate
			newPost["endDate"] = tripPost.endDate
			newPost["comment"] = tripPost.comment

			//Save the post
			newPost.saveInBackgroundWithBlock({ (success, error) -> Void in

				if(success) {

					//Update the TableView
					self.fetchObjectsFromParseDatabase()

				} else {

					//Report the user that an error has occured
					var errorMessage = error!.userInfo!["error"] as! String
					let alertView = UIAlertView(title: "Error", message: errorMessage, delegate: self, cancelButtonTitle: "Ok")
					alertView.alertViewStyle = UIAlertViewStyle.Default
					alertView.show()
				}
			})
		}
	}

	@IBAction func unwindToMainViewFromEditTrip(sender: UIStoryboardSegue) {

		let sourceViewController: EditTripViewController = sender.sourceViewController as! EditTripViewController
		self.editTrip = sourceViewController.trip

		if(editTrip != nil) {

			//Set up a querry to find the current object being edited
			var query = PFQuery(className:"Posts")
			query.getObjectInBackgroundWithId(editTrip.objectID, block: { (editObject, error) -> Void in


				if (error == nil) {

					//update the object with the new values
					if let editObject = editObject {
						editObject["destination"] = self.editTrip.destination
						editObject["startDate"] = self.editTrip.startDate
						editObject["endDate"] = self.editTrip.endDate
						editObject["comment"] = self.editTrip.comment
					}
					editObject!.saveInBackground()

				} else {

					//Report the user that an error has occured
					var errorMessage = error!.userInfo!["error"] as! String
					let alertView = UIAlertView(title: "Error", message: errorMessage, delegate: self, cancelButtonTitle: "Ok")
					alertView.alertViewStyle = UIAlertViewStyle.Default
					alertView.show()

				}
			})
		}
	}

	func saveQuerryObjects(objects:[AnyObject]?) -> [Trip]? {

		//Save the querry objects to our model for future reference
		var tripArray:[Trip] = []
		var trip:Trip = Trip()

		for object in objects! {

			trip.comment = object["comment"] as! String
			trip.startDate = object["startDate"] as! String
			trip.endDate = object["endDate"] as! String
			trip.destination = object["destination"] as! String
			trip.user = object["username"] as! String
			trip.objectID = object.objectId as String!

			tripArray.append(trip)

		}

		return tripArray

	}

	func deleteobjectFromDatabase(objedId: String) {

		//Delete the object, provided the id
		var querry: PFQuery = PFQuery(className: "Posts")
		querry.whereKey("objectId", equalTo: objedId)
		querry.findObjectsInBackgroundWithBlock { (object, error) -> Void in

			if(error == nil) {

				//Delete the object from the database
				object?.first?.deleteInBackground()

			} else {

				//Report the user that an error has occured
				var errorMessage = error!.userInfo!["error"] as! String
				let alertView = UIAlertView(title: "Error", message: errorMessage, delegate: self, cancelButtonTitle: "Ok")
				alertView.alertViewStyle = UIAlertViewStyle.Default
				alertView.show()

			}

		}

	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

		//Prepare for the segue
		if segue.identifier == "ToEditTrip" {

			let nav = segue.destinationViewController as! UINavigationController
			let editTripViewController = nav.topViewController as! EditTripViewController
			editTripViewController.trip = self.editTrip

		}
	}

	func checkDate() {

		let now = NSDate()


	}
}






















