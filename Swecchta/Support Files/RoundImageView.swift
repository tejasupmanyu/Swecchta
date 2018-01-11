//
//  RoundImageView.swift
//  Swecchta
//
//  Created by Tejas Upmanyu on 10/01/18.
//  Copyright © 2018 VisionArray. All rights reserved.
//

import UIKit
@IBDesignable
class RoundImageView: UIImageView {

    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet{
            self.layer.cornerRadius = cornerRadius
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
