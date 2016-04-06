//
//  GameInfo.swift
//  MonstersLoveIceCream
//
//  Created by CJ Hodnefield on 3/5/16.
//  Copyright © 2016 CJ Hodnefield. All rights reserved.
//

import UIKit

// MARK: - Class summary
// This class is a singleton that contains useful data and methods for the entire app

/// - Attributions: http://stackoverflow.com/questions/24059327/detect-current-device-with-ui-user-interface-idiom-in-swift
enum UIUserInterfaceIdiom: Int {
    case Unspecified
    
    case Phone // iPhone and iPod touch style UI
    case Pad // iPad style UI
}

class GameInfo {
    static let sharedInstance = GameInfo()
    private init() {} // This prevents others from using the default '()' initializer for this class
    
    // MARK: - Properties
    let developer = "CJ Hodnefield"
    var ratingAlertWasShown = false
    
    var splashBackgroundName: String!
    var mainMenuBackgroundName: String!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let mapNameDict: [String:String] = [
        "park" : "Simple Park",
        "park2" : "Winding Park"
    ]
    
    // MARK: - Launch set-up methods
    /// - Attributions: http://stackoverflow.com/questions/29984654/nsuserdefaults-key-initialization-when-app-starts-for-the-first-time
    func launchSetup() {
        // A way to clear defaults for debugging
        //defaults.removeObjectForKey("Initial Launch")
        
        let defaultDictionary = [ "name_preference" : "CJ", "slider_preference" : 1.0, "musicLevel" : 0.5, "effectsLevel" : 0.5]
        defaults.registerDefaults(defaultDictionary)
        defaults.synchronize()
        
        // If this is not the first launch
        if (defaults.objectForKey("Initial Launch") != nil) {
            print("Initial Launch Date: \(defaults.objectForKey("Initial Launch"))")
            let launchCount = defaults.integerForKey("launchCount")
            defaults.setInteger(launchCount + 1, forKey: "launchCount")
            
        // If this is the first launch
        } else {
            defaults.setObject(NSDate(), forKey: "Initial Launch")
            defaults.setInteger(1, forKey: "launchCount")
            let levels = createLevelsArray()
            defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(levels), forKey: "levels")
        }
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            splashBackgroundName = "iPadSplash"
            mainMenuBackgroundName = "iPadMainMenu"
        } else {
            splashBackgroundName = "iPhoneSplash"
            mainMenuBackgroundName = "iPhoneMainMenu"
        }
        
        print("This app has been launched \(defaults.objectForKey("launchCount")!) times")
    }
    
    func createLevelsArray() -> [String] {
        //        var levels = [Level]()
        //        levels += [Level(name: "park", difficulty: "easy")]
        //        levels += [Level(name: "park2", difficulty: "easy")]
        
        let levels = ["park", "park2"]
        
        return levels
    }
    
    func levelNameByKey(key: String) -> String {
        return mapNameDict[key]!
    }
    
    func enemyNameByKey(key: Int) -> String {
        var name = ""
        switch key {
        case 1:
            name = "greenGuy"
        case 2:
            name = "yellowGuy"
        case 3:
            name = "redGuy"
        case 4:
            name = "indigoGuy"
        case 5:
            name = "blueGuy"
        case 6:
            name = "pinkGuy"
        case 7:
            name = "purpleGuy"
        case 8:
            name = "cyanGuy"
        case 9:
            name = "blueDragon"
        case 10:
            name = "phoenix"
        default:
            name = "phoenix"
        }
        return name
    }
}
