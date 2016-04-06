//
//  LevelSelect.swift
//  MonstersLoveIceCream
//
//  Created by CJ Hodnefield on 3/9/16.
//  Copyright © 2016 CJ Hodnefield. All rights reserved.
//

import UIKit

// MARK: - Class summary
// A collection view used to select a level to play the game on

class LevelSelect: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // MARK: - Properties
    @IBOutlet weak var collectionView: UICollectionView!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let gameInfo = GameInfo.sharedInstance
    
    let reuseIdentifier = "levelCell"
    
    //    var selectedLevel: String?
    //    var selectedDifficulty: String?
    
    var levels = [String]()
    
    // MARK: - Life-cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        let background = UIImageView(image: UIImage(named: "background"))
        background.frame = self.view.frame
        self.view.addSubview(background)
        self.view.sendSubviewToBack(background)
    }
    
    override func viewWillAppear(animated: Bool) {
        if levels.count == 0 {
            levels = NSKeyedUnarchiver.unarchiveObjectWithData(defaults.objectForKey("levels") as! NSData) as! [String]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /// - Attributions: https://developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson8.html#//apple_ref/doc/uid/TP40015214-CH16-SW1
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "levelSelected" {
            
            // Get the cell that generated the segue
            let gameViewController = segue.destinationViewController as! GameViewController
            
            if let selectedLevelCell = sender as? LevelCell {
                gameViewController.selectedLevel = selectedLevelCell.name
                gameViewController.selectedDifficulty = selectedLevelCell.difficulty
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levels.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! LevelCell
        
        // Configure the cell
        
        // Position cell properties
        //let center = cell.center
        //cell.levelImage.frame = cell.frame
        //cell.levelImage.center = center
        
        // Load data
        let levelName = levels[indexPath.item]
        cell.name = levelName
        cell.difficulty = "easy"
        cell.levelName.text = gameInfo.levelNameByKey(levelName)
        cell.levelImage.image = UIImage(named: levelName)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
}
