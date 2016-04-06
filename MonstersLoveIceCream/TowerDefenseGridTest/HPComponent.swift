//
//  HPComponent.swift
//  MonstersLoveIceCream
//
//  Created by CJ Hodnefield on 2/27/16.
//  Copyright © 2016 CJ Hodnefield. All rights reserved.
//

import GameplayKit
import SpriteKit

// MARK: - Class summary
// This component is used to track the HP of enemy entities
// HP stands for 'Hit Points'

class HPComponent: GKComponent {
    
    // MARK: - Properties
    // Current and max HP
    var hp: Double!
    var maxHP: Double!
    var previousHP: Double!
    
    init(hp: Double) {
        self.hp = hp
        self.maxHP = hp
        self.previousHP = hp
    }
    
    // Updates the current hp
    func setHP(hp: Double) {
        self.previousHP = self.hp
        self.hp = hp
    }
}