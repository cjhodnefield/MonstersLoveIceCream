//
//  MovementComponent.swift
//  MonstersLoveIceCream
//
//  Created by CJ Hodnefield on 2/24/16.
//  Copyright © 2016 CJ Hodnefield. All rights reserved.
//

import GameplayKit
import SpriteKit

// MARK: - Class summary
// This component is used to implement and control enemy movement along the path

class MovementComponent: GKComponent {
    
    // MARK: - Properties
    var sprite: SKNode
    
    var nextGridPosition: int2!
    
    init(sprite: SKNode) {
        self.sprite = sprite
    }
    
    // MARK: - Pathfinding
    func moveToCoordinate(coordinate: int2, duration: NSTimeInterval) {
        if let scene = sprite.scene as? GameScene {
            let location = scene.pointForCoordinate(coordinate)
            let action = SKAction.moveTo(location, duration: duration)
            
            sprite.runAction(action)
        }
    }
    
    func followPath(path: [GKGridGraphNode]) {
        // Create an array of SKActions called sequence
        var sequence = [SKAction]()
        
        if let scene = sprite.scene as? GameScene {
            for node in path {
                let location = scene.pointForCoordinate(node.gridPosition)
                let update = SKAction.runBlock( { [unowned self] in
                    let enemy = self.entity as! Enemy
                    enemy.gridPosition = node.gridPosition
                    
                    if enemy.gridPosition.x == scene.enemyEnd.x && enemy.gridPosition.y == scene.enemyEnd.y {
                        print("an enemy hit the base")
                        scene.enemyHitBase(enemy)
                    }
                })
                
                let enemy = self.entity as! Enemy
                let speed = enemy.speed
                let duration = 1 - (speed - 1) / 10
                let action = SKAction.moveTo(location, duration: duration)
                
                sequence += [action, update]
            }
        }
        
        // Run the entire sequence
        sprite.runAction(SKAction.sequence(sequence))
    }
}
