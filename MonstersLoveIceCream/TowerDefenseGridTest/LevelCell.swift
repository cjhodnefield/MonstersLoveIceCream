//
//  LevelCell.swift
//  MonstersLoveIceCream
//
//  Created by CJ Hodnefield on 3/5/16.
//  Copyright © 2016 CJ Hodnefield. All rights reserved.
//

import UIKit

// MARK: - Class summary
// Custom cell for the collection view to choose a level

class LevelCell: UICollectionViewCell {
    // MARK: - Properties
    @IBOutlet weak var levelName: UILabel!
    @IBOutlet weak var levelImage: UIImageView!
    
    var name: String!
    var difficulty: String!
}
