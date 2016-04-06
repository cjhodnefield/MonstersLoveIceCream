//
//  MoneyComponent.swift
//  MonstersLoveIceCream
//
//  Created by CJ Hodnefield on 2/27/16.
//  Copyright © 2016 CJ Hodnefield. All rights reserved.
//

import GameplayKit
import SpriteKit

// MARK: - Class summary
// This component is used to track the value of entities
// For enemies, this is the value they give the player when they are defeated
// For turrets, this is the value they can be sold for (selling is not yet implemented)

class MoneyComponent: GKComponent {
    
    // MARK: - Properties
    var cost: Int? {
        didSet {value = cost! / 2}
    }
    var value: Int?
    
    init(cost: Int?, value: Int?) {
        self.cost = cost
        self.value = value
    }
    
    func setValue(value: Int) {
        self.value = value
    }
}
