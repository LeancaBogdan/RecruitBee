//
//  CompanyTableViewCell.swift
//  RecruitBee
//
//  Created by Alexandru Popsor on 14/01/2020.
//  Copyright © 2020 Adrian-Bogdan Leanca. All rights reserved.
//

import UIKit

class CompanyTableViewCell: UITableViewCell {

    
    @IBOutlet weak var jobImage: UIImageView!
    @IBOutlet weak var jobTitleTextField: UILabel!
    @IBOutlet weak var durationTextField: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
