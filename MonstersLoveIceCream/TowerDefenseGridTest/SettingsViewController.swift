//
//  SettingsViewController.swift
//  MonstersLoveIceCream
//
//  Created by CJ Hodnefield on 3/5/16.
//  Copyright © 2016 CJ Hodnefield. All rights reserved.
//

import UIKit

// MARK: - Class summary
// A simple view controller to display settings to the user

class SettingsViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var developerLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var musicLevelSlider: UISlider!
    @IBOutlet weak var effectsLevelSlider: UISlider!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let gameInfo = GameInfo.sharedInstance
    
    // MARK: - Life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "defaultsChanged", name: NSUserDefaultsDidChangeNotification, object: nil)
        
        let background = UIImageView(image: UIImage(named: "background"))
        background.frame = self.view.frame
        self.view.addSubview(background)
        self.view.sendSubviewToBack(background)
    }
    
    func defaultsChanged() {
        //print(defaults.dictionaryRepresentation())
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        versionLabel.text = "Version \(NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")!)"
        developerLabel.text = "Developed by \(gameInfo.developer)"

        musicLevelSlider.value = defaults.floatForKey("musicLevel")
        effectsLevelSlider.value = defaults.floatForKey("effectsLevel")
    }
    
    override func viewWillDisappear(animated: Bool) {
        defaults.setFloat(musicLevelSlider.value, forKey: "musicLevel")
        defaults.setFloat(effectsLevelSlider.value, forKey: "effectsLevel")
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
    /// - Attributions: http://www.ioscreator.com/tutorials/uislider-tutorial-ios8-swift

}
