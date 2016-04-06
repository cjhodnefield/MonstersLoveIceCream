//
//  Enemy.swift
//  MonstersLoveIceCream
//
//  Created by CJ Hodnefield on 2/27/16.
//  Copyright © 2016 CJ Hodnefield. All rights reserved.
//

import GameplayKit
import SpriteKit

// MARK: - Class summary
// Instances of this class are enemy GKEntities
// The class contains info for all enemy types and helper functions to govern their use in GameScene

class Enemy: GKEntity {
    
    // MARK: - Properties
    var gridPosition: int2!
    var endGridPosition: int2!
    let name: String!
    
    // Visual properties
    var type: String!
    var sizeFactor: Double!
    
    // Mechanical properties
    var maxHP: Double!
    var speed: Double!
    var damage: Int!
    var value: Int!
    
    // MARK: - Initialization
    init(gridPosition: int2, endGridPosition: int2, name: String) {
        self.gridPosition = gridPosition
        self.endGridPosition = endGridPosition
        self.name = name
        
        switch name {
        // Normal monsters
        case "greenGuy":
            maxHP = 200
            speed = 3
            damage = 1
            value = 20
            type = "normal"
        case "yellowGuy":
            maxHP = 450
            speed = 4
            damage = 1
            value = 30
            type = "normal"
        case "redGuy":
            maxHP = 10
            speed = 2
            damage = 1
            value = 25
            type = "normal"
        case "indigoGuy":
            maxHP = 10
            speed = 2
            damage = 1
            value = 25
            type = "normal"
        case "blueGuy":
            maxHP = 10
            speed = 2
            damage = 1
            value = 25
            type = "normal"
        case "pinkGuy":
            maxHP = 10
            speed = 2
            damage = 1
            value = 25
            type = "normal"
        case "purpleGuy":
            maxHP = 10
            speed = 2
            damage = 1
            value = 25
            type = "normal"
        case "cyanGuy":
            maxHP = 10
            speed = 2
            damage = 1
            value = 25
            type = "normal"
        
        // Boss monsters
        case "blueDragon":
            maxHP = 1000
            speed = 1
            damage = 1
            value = 100
            type = "boss"
        case "phoenix":
            maxHP = 2000
            speed = 1
            damage = 1
            value = 100
            type = "boss"
        default:
            break
        }
        
        if type == "boss" {
            sizeFactor = 3.0
        } else {
            sizeFactor = 1.4
        }
    }
}
