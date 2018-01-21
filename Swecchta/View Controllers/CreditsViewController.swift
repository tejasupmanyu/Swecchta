//
//  CreditsViewController.swift
//  Swecchta
//
//  Created by Tejas Upmanyu on 21/01/18.
//  Copyright © 2018 VisionArray. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController, PaperOnboardingDataSource {

    @IBOutlet weak var creditsView: PaperOnboarding!
    
    @IBOutlet weak var closeButton: UIButton!
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        creditsView.dataSource = self
        creditsView.bringSubview(toFront: closeButton)
    }

    func onboardingItemsCount() -> Int {
        return 5
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        
        let backgroundColorOne = UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1)
        let backgroundColorTwo = UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha: 1)
        let backgroundColorThree = UIColor(red: 168/255, green: 200/255, blue: 78/255, alpha: 1)
        let backgroundColorfour = UIColor(red: 220/255, green: 200/255, blue: 178/255, alpha: 1)
        let backgroundColorfive = UIColor(red: 97/255, green: 198/255, blue: 227/255, alpha: 1)
        let textColor = UIColor.white
        let DescriptionColor = UIColor.white
        let textFont = UIFont.systemFont(ofSize: 32, weight: .heavy)
        let DescriptionFont = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        
        let one = OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Tejas"), title: "Tejas Upmanyu", description: "iOS Developer/ UX & UI", pageIcon: UIImage(), color: backgroundColorOne, titleColor: textColor, descriptionColor: DescriptionColor, titleFont: textFont, descriptionFont: DescriptionFont)
        
       let two =  OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Shabbir"), title: "Shabbir Hussain", description: "Android Developer", pageIcon: UIImage(), color: backgroundColorTwo, titleColor: textColor, descriptionColor: DescriptionColor, titleFont: textFont, descriptionFont: DescriptionFont)
        
       let three =  OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Shivam"), title: "Shivam Bharadwaj", description: "Web Developer", pageIcon: UIImage(), color: backgroundColorThree, titleColor: textColor, descriptionColor: DescriptionColor, titleFont: textFont, descriptionFont: DescriptionFont)
        
       let four =  OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Neha"), title: "Neha Shukla", description: "Shukla Pari", pageIcon: UIImage(), color: backgroundColorfour, titleColor: textColor, descriptionColor: DescriptionColor, titleFont: textFont, descriptionFont: DescriptionFont)
        
        let five = OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "Suhasini"), title: "Suhasini Singyan", description: "Team Leader", pageIcon: UIImage(), color: backgroundColorfive, titleColor: textColor, descriptionColor: DescriptionColor, titleFont: textFont, descriptionFont: DescriptionFont)
        
        
        return [one, two, three, four, five][index]
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
