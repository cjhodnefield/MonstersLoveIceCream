//
//  Instructions.swift
//  MonstersLoveIceCream
//
//  Created by CJ Hodnefield on 3/12/16.
//  Copyright © 2016 CJ Hodnefield. All rights reserved.
//

import UIKit

// MARK: - Class summary
// A table view used to display the instructions to the user

let reuseIdentifier = "infoCell"

class Instructions: UITableViewController {

    // MARK: Properties
    var instructions: [String]!
    var imageNames: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        instructions = generateInstructionText()
        imageNames = generateImageNames()
        
        // Set table view cells for auto-resizing
        /// - Attributions: Lecture 8
        //tableView.estimatedRowHeight = 150
        //tableView.rowHeight = UITableViewAutomaticDimension
        
        let background = UIImageView(image: UIImage(named: "background"))
        background.frame = self.view.frame
        self.view.addSubview(background)
        self.view.sendSubviewToBack(background)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instructions.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! InfoCell

        cell.infoLabel.text = instructions[indexPath.row]
        let image = UIImage(named: imageNames[indexPath.row])
        cell.infoImage.image = image
        //cell.infoImage.contentMode = .ScaleAspectFit

        cell.backgroundColor = UIColor.grayColor()
        cell.tintColor = UIColor.whiteColor()
        cell.infoLabel.textColor = UIColor.whiteColor()
        
        return cell
    }

    // MARK: Data
    func generateInstructionText() -> [String] {
        var instructions = [String]()
        
        instructions += ["Your store is well known for producing delicious ice cream. Hurray for ice cream!"]
        instructions += ["Unfortunately, there are monsters! And everyone knows that monsters love ice cream!"]
        instructions += ["As such, monsters are going to try to steal your ice cream - don't let them! They will move along the path, and you will lose a life if they get to your store."]
        instructions += ["If too many monsters make it to your store, you won't have any ice cream left, and your store will go out of business!"]
        instructions += ["Use your advanced knowledge of architecture and ballistics to build turrets on the grass to defend your ice cream! Tap to place a turret."]
        instructions += ["Building turrets is expensive though, so spend your cash wisely."]
        instructions += ["As you defeat monsters, you will earn more cash, which you can spend on more turrets!"]
        instructions += ["Watch out for the boss monsters! They love ice cream more than anyone!"]
        
        return instructions
    }
    
    func generateImageNames() -> [String] {
        return ["info1", "info2", "info3", "info4", "info5", "info6", "info7", "info8"]
    }
}
