//
//  usersCollectionViewCell.swift
//  InstagramStories
//
//  Created by mac05 on 05/10/17.
//

import UIKit

class usersCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblUserName.textAlignment = .center
        self.imgView.layer.cornerRadius = self.imgView.frame.size.height / 2;
        self.imgView.layer.borderColor = UIColor.white.cgColor
        self.imgView.layer.borderWidth = 3
        self.imgView.clipsToBounds = true
    }
}
