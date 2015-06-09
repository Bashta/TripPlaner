//
//  ViewController.swift
//  Travel Planer
//
//  Created by Alb on 6/3/15.
//  Copyright (c) 2015 01Logic. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

	var vc = LogInViewController()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		//test parse
//		let testObject = PFObject(className: "TestObject")
//		testObject["foo"] = "Teraaa"
//		testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
//			println("Object has been saved.")
//		}


	}

	override func viewDidAppear(animated: Bool) {
		//self.presentViewController(vc, animated: true, completion: nil)
		var window = UIWindow.mai
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

