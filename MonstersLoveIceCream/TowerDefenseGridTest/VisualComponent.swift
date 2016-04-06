//
//  VisualComponent.swift
//  MonstersLoveIceCream
//
//  Created by CJ Hodnefield on 2/24/16.
//  Copyright © 2016 CJ Hodnefield. All rights reserved.
//

import GameplayKit
import SpriteKit

// MARK: - Class summary
// This component is used to handle the visual elements for turrets, enemies, and anything else on the GameScene

class VisualComponent: GKComponent {
    
    // MARK: - Properties
    var sprite: SKNode!
    var projectileSprite: SKSpriteNode?
    
    init(sprite: SKNode, projectileSprite: SKSpriteNode?) {
        self.sprite = sprite
        self.projectileSprite = projectileSprite
    }
    
    func setSpeed(speed: CGFloat) {
        let action = SKAction.speedTo(speed, duration: 0.1)
        sprite.runAction(action)
    }
}
