//
//  MainMenuViewController.swift
//  MonstersLoveIceCream
//
//  Created by CJ Hodnefield on 2/27/16.
//  Copyright © 2016 CJ Hodnefield. All rights reserved.
//

import UIKit

// MARK: - Class summary
// The main menu view
// The user can navigate to and from this menu to access the other parts of the app

/// - Attributions: http://ic8.link/2969
class MainMenuViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var chooseLevelButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let gameInfo = GameInfo.sharedInstance
    
    var instructionTextView: UITextView!
    var instructionView: UIView!
    
    // MARK: - Life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background = UIImageView(image: UIImage(named: GameInfo.sharedInstance.mainMenuBackgroundName))
        background.frame = self.view.frame
        self.view.addSubview(background)
        self.view.sendSubviewToBack(background)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        // Display an alert on the 5th launch suggesting that the user rate this app on the app store
        if !gameInfo.ratingAlertWasShown && defaults.integerForKey("launchCount") == 5 {
            let rateAppAlert = UIAlertController(title: "Rate This App", message: "What did you think of this app? Go rate it on the app store to let us know!", preferredStyle: .Alert)
            rateAppAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(rateAppAlert, animated: true, completion: nil)
            gameInfo.ratingAlertWasShown = true
        }
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

    // MARK: - Actions
    
}
