//
//  FiringComponent.swift
//  MonstersLoveIceCream
//
//  Created by CJ Hodnefield on 2/27/16.
//  Copyright © 2016 CJ Hodnefield. All rights reserved.
//

import GameplayKit
import SpriteKit

// MARK: - Class summary
// This component implements and controls how turrets are able to fire at enemies

class FiringComponent: GKComponent {
    
    // MARK: - Properties
    let rotationAngle = CGFloat(M_PI * -1)
    let rotationSpeed = 0.1
    
    var sprite: SKSpriteNode!
    var emitter: SKEmitterNode?
    var damage: Double!
    var fireRate: Double!
    var slowTo: CGFloat?
    
    var time: Double!
    
    var enemiesInRange = [Enemy]()
    var timeTracker = [Double]()
    var projectilesToFire = [Double]()
    
    init(sprite: SKSpriteNode, emitter: SKEmitterNode?, damage: Double, fireRate: Double, slowTo: CGFloat?) {
        self.sprite = sprite
        self.emitter = emitter
        self.damage = damage
        self.fireRate = fireRate
        
        // Future turret slow effect (not implemented yet)
        self.slowTo = slowTo
        
        super.init()
    }
    
    func enemyEnteredTurretRange(enemy: Enemy) {
        aimAtEnemy(enemy)
    }
    
    func enemyExitedTurretRange(enemy: Enemy) {
        removeEnemy(enemy)
    }
    
    func aimAtEnemy(enemy: Enemy) {
        let startAngle = calculateAngle(sprite.parent!, node2: enemy.componentForClass(VisualComponent)!.sprite)
        
        let rotateToStart = SKAction.rotateToAngle(startAngle, duration: rotationSpeed, shortestUnitArc: true)
        sprite.runAction(rotateToStart) { [unowned self] in
            self.enemiesInRange.append(enemy)
            self.timeTracker.append(self.time)
            self.projectilesToFire.append(1)
        }
    }
    
    func removeEnemy(enemy: Enemy) {
        var index = 0
        
        for iEnemy in enemiesInRange {
            if enemy == iEnemy {
                enemiesInRange.removeAtIndex(index)
                timeTracker.removeAtIndex(index)
                projectilesToFire.removeAtIndex(index)
                
                break
            }
            index++
        }
    }
    
    func enemyInRange(enemy: Enemy) {
        var index = 0
        
        for iEnemy in enemiesInRange {
            if iEnemy == enemy {
                break
            }
            index++
        }
        
        let enemyVisualComponent = enemy.componentForClass(VisualComponent)!
        let enemySprite = enemyVisualComponent.sprite
        
        let angle = calculateAngle(sprite.parent!, node2: enemySprite)
        
        let rotateToAngle = SKAction.rotateToAngle(angle, duration: 0, shortestUnitArc: true)
        sprite.runAction(rotateToAngle)
        
        let timeSinceLastUpdate = time - timeTracker[index]
        let projectiles = ceil(fireRate * timeSinceLastUpdate)
        projectilesToFire[index] += projectiles
        
        let totalDamage = projectiles * damage
        
        let hpComponent = enemy.componentForClass(HPComponent)!
        var hp = hpComponent.hp
        hp = hp - totalDamage
        hpComponent.setHP(hp)
        
        if let scene = sprite.scene as? GameScene {
            
            if projectilesToFire[index] >= 1 {
                scene.updateEnemyHP(enemy)
                scene.fireProjectileFromEntity(entity!, towardsEnemy: enemy, angle: angle)
                projectilesToFire[index] -= floor(projectilesToFire[index])
            }
        }
        
        if hp <= 0 {
            // Enemy was defeated
            print("\(enemy.name) was defeated")
            removeEnemy(enemy)
        }
    }
    
    /// - Attributions: http://www.raywenderlich.com/57368/trigonometry-game-programming-sprite-kit-version-part-1
    func calculateAngle(node1: SKNode, node2: SKNode) -> CGFloat {
        var angle = atan((node1.position.x - node2.position.x) / (node1.position.y - node2.position.y))
        
        if node2.position.y > node1.position.y {
            angle *= -1
        } else {
            angle = CGFloat(M_PI) - angle
        }
        
        return angle
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)
        
        time = seconds
        
        if enemiesInRange.count > 0 {
            enemyInRange(enemiesInRange[0])
            
            if timeTracker.count > 0 {
                timeTracker[0] = seconds
            }
        }
    }
}
