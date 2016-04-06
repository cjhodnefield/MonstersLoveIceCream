//
//  Turret.swift
//  MonstersLoveIceCream
//
//  Created by CJ Hodnefield on 2/27/16.
//  Copyright © 2016 CJ Hodnefield. All rights reserved.
//

import GameplayKit
import SpriteKit

// MARK: - Class summary
// Instances of this class are turret GKEntities
// The class contains info for all turret types and helper functions to govern their use in GameScene

class Turret: GKEntity {
    
    // MARK: - Properties
    var gridPosition: int2!
    let name: String!
    
    // Visual properties
    var projectileColor: UIColor!
    var projectileSize: CGSize!
    
    // Mechanical properties
    var damage: Double!
    var fireRate: Double!
    var range: Double!
    var slowTo: CGFloat?
    var cost: Int! {
        didSet {value = cost / 2}
    }
    var value: Int!
    
    var emitter: SKEmitterNode?
    
    // MARK: - Initialization
    init(gridPosition: int2, name: String) {
        self.gridPosition = gridPosition
        self.name = name
        
        switch name {
        case "bulletTurret":
            projectileColor = UIColor.grayColor()
            projectileSize = CGSize(width: 2, height: 2)
            damage = 1
            fireRate = 1
            range = 3
            cost = 100
        case "glueTurret":
            projectileColor = UIColor.yellowColor()
            projectileSize = CGSize(width: 3, height: 2)
            damage = 0
            fireRate = 10
            range = 3
            cost = 120
        default:
            break
        }
    }
}
