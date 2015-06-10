//
//  MainTableViewCell.swift
//  Travel Planer
//
//  Created by Alb on 6/5/15.
//  Copyright (c) 2015 01Logic. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {


	@IBOutlet weak var destinationLabel: UILabel!
	@IBOutlet weak var stardDateLabel: UILabel!
	@IBOutlet weak var endDateLabel: UILabel!
	@IBOutlet weak var descriptionTextView: UITextView!
	@IBOutlet weak var daysToStartLabel: UILabel!
	@IBOutlet weak var daysLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	
}
