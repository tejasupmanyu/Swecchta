//
//  AllPostsTableViewCell.swift
//  Swecchta
//
//  Created by Tejas Upmanyu on 12/01/18.
//  Copyright © 2018 VisionArray. All rights reserved.
//

import UIKit

class AllPostsTableViewCell: UITableViewCell {

    @IBOutlet weak var UserProfileImage: RoundImageView!
    
    @IBOutlet weak var dateOfPostLabel: UILabel!
    
    @IBOutlet weak var postImageView: RoundImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    @IBOutlet weak var postDescriptionLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 6.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
