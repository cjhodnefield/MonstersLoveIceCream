//
//  GameViewController.swift
//  MonstersLoveIceCream
//
//  Created by CJ Hodnefield on 2/23/16.
//  Copyright (c) 2016 CJ Hodnefield. All rights reserved.
//

import UIKit
import SpriteKit

// MARK: - Class summary
// The view controller that contains the GameScene

class GameViewController: UIViewController {

    // MARK: Properties
    var selectedLevel: String?
    var selectedDifficulty: String?
    
    var gameScene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let scene = GameScene(fileNamed: "GameScene") {
            self.gameScene = scene
            
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .ResizeFill
            
            if let selectedLevel = selectedLevel, selectedDifficulty = selectedDifficulty {
                scene.levelName = selectedLevel
                scene.difficulty = selectedDifficulty
            }
            
            scene.viewController = self
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
