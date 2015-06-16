//
//  SignUpViewController.swift
//  Travel Planer
//
//  Created by Alb
//  Copyright (c) 2015 01Logic. All rights reserved.
//

import Parse
import UIKit
import ParseFacebookUtils

// MARK: Protocol
protocol SignUpViewControllerDelegate {
	func onSignUpButtonPressed(signUpViewController: SignUpViewController)
	func onSignUpWithFacebookButtonPressed(signUpViewController: SignUpViewController)
}

// MARK: - Class
class SignUpViewController: UIViewController {

	// MARK: - Properties
	@IBOutlet weak var userNameTextField:UITextField!
	@IBOutlet weak var userEmailTextField:UITextField!
	@IBOutlet weak var userPasswordTextField:UITextField!
	@IBOutlet weak var userRepeatPasswordTextField:UITextField!

	@IBOutlet weak var statusLabel:UILabel!

	var delegate: SignUpViewControllerDelegate?

	// MARK: - Class Setup
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)

		self.statusLabel.text = ""
	}

	// MARK: - SignUp methods

	@IBAction func signUpButtonPressed(sender: UIButton) {
		if (userNameTextField.text.isEmpty || userPasswordTextField.text.isEmpty || userEmailTextField.text.isEmpty) {
			self.statusLabel.text = "Please enter your username,email and password"
			userEmailTextField.becomeFirstResponder()
			return

		} else if (userNameTextField.text.length < 4) {
			self.statusLabel.text = "Username must be at least 5 charaters long"
			userNameTextField.becomeFirstResponder()
			return

		}else if (userPasswordTextField.text.length < 5) {
			self.statusLabel.text = "Password must be at least 6 charaters long"
			userPasswordTextField.becomeFirstResponder()
			return

		} else if (userPasswordTextField.text != userRepeatPasswordTextField.text) {
			self.statusLabel.text = "Passwords do not match"
			self.userNameTextField.becomeFirstResponder()
			return

		} else if (!userEmailTextField.text.isEmail()) {
			self.statusLabel.text = "Please enter a valid email"
			self.userEmailTextField.becomeFirstResponder()
			return

		}

		// Create a user a try to Sign Up.
		let user = PFUser()
		user.username = userNameTextField.text
		user.password = userPasswordTextField.text
		user.email = userEmailTextField.text

		user.signUpInBackgroundWithBlock {
			(succeed: Bool, error: NSError?) -> Void in

			if error != nil {
				// deal with the error
				self.statusLabel.text = error?.userInfo?["error"] as? String

			}else {
				// Hell yeah! Dismiss the window and let them in
				self.delegate?.onSignUpButtonPressed(self)
			}
		}
	}

	@IBAction func signUpWithFacebookButtonPressed(sender: UIButton) {

		//Set permissions required from the facebook user account
		let permissions: Array = ["email", "public_profile"]

		PFFacebookUtils.logInWithPermissions(permissions, block: { (user, error) -> Void in

			if (user == nil) {

				//Do nothing! The log in view will not be dismmised

			} else if (user!.isNew) {

				self.delegate?.onSignUpWithFacebookButtonPressed(self)

			} else {

				self.delegate?.onSignUpWithFacebookButtonPressed(self)
				
			}
			
		})
	}
	
}


















