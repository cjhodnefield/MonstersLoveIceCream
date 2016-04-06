//
//  InfoCell.swift
//  MonstersLoveIceCream
//
//  Created by CJ Hodnefield on 3/12/16.
//  Copyright © 2016 CJ Hodnefield. All rights reserved.
//

import UIKit

// MARK: - Class summary
// Custom cell to display info in the instructions table view

class InfoCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var infoImage: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
