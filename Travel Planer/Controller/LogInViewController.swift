//
//  File.swift
//  Travel Planer
//
//  Created by Alb on 6/3/15.
//  Copyright (c) 2015 01Logic. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtils

// MARK: Protocol

protocol LogInViewControllerDelegate {
	func onRegisterButtonPressed(loginViewController : LogInViewController)
	func onFacebookLoginButtonPressed(loginViewController : LogInViewController)
	func onLogInButtonPressed(loginViewController : LogInViewController)
}

// MARK: - Class
class LogInViewController: UIViewController {

	// MARK: - Properties

	@IBOutlet weak var userNameTextField:UITextField!
	@IBOutlet weak var userPasswordTextField:UITextField!

	@IBOutlet weak var statusLabel:UILabel!

	var delegate: LogInViewControllerDelegate?

	// MARK: - Class Setup

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		self.statusLabel.text = ""
	}

	// MARK: - LogIn / SignUp methods

	@IBAction func logInButtonPressed(sender: AnyObject) {

		//Check if the fields are not empty
		if (userNameTextField.text.isEmpty || userPasswordTextField.text.isEmpty) {

			self.statusLabel.text = "Please enter your username and password"

			return
		}

		// Try to log in the user with the given credentials
		PFUser.logInWithUsernameInBackground(userNameTextField.text, password: userPasswordTextField.text, block: { (success, error) -> Void in

			if error != nil {

				// Handle error
				let errorMessage = error!.userInfo!["error"] as! String
				self.statusLabel.text = errorMessage

			} else {

				// Succsess, let the user in
				if self.delegate != nil {
					self.delegate!.onLogInButtonPressed(self)
				}
			}
		})

	}

	//Call the delegate after the button was pressed
	@IBAction func registerButtonPressed(sender: AnyObject) {
		
		self.delegate!.onRegisterButtonPressed(self)

	}

	@IBAction func fabookLogInButton(sender: AnyObject) {

		//Set permissions required from the facebook user account
		let permissions: Array = ["email", "public_profile"]

		PFFacebookUtils.logInWithPermissions(permissions, block: { (user, error) -> Void in

			if (user == nil) {

				//Do nothing! The log in view will not be dismmised

			} else if (user!.isNew) {

				self.delegate?.onFacebookLoginButtonPressed(self)

			} else {

				self.delegate?.onFacebookLoginButtonPressed(self)

			}

		})
	}

}








