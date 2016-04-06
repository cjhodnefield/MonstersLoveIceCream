//
//  SplashScreen.swift
//  MonstersLoveIceCream
//
//  Created by CJ Hodnefield on 3/6/16.
//  Copyright © 2016 CJ Hodnefield. All rights reserved.
//

import UIKit

// MARK: - Class summary
// Splash screen displayed before the main menu is shown

class SplashScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let background = UIImageView(image: UIImage(named: GameInfo.sharedInstance.splashBackgroundName))
        background.frame = self.view.frame
        self.view.addSubview(background)
        self.view.sendSubviewToBack(background)

        // Initializes a timer that fires the segueToMainMenu method
        /// - Attributions: http://stackoverflow.com/questions/26379462/how-do-i-perform-an-auto-segue-in-xcode-6-using-swift
        _ = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "segueToMainMenu", userInfo: nil, repeats: false)
    }
    
    func segueToMainMenu() {
        self.performSegueWithIdentifier("segueToMainMenu", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
