//
//  GameScene.swift
//  MonstersLoveIceCream
//
//  Created by CJ Hodnefield on 2/23/16.
//  Copyright (c) 2016 CJ Hodnefield. All rights reserved.
//

import GameplayKit
import SpriteKit

// MARK: - Class summary
// This class handles the SKScene on which all of the game logic is happening
// It uses all of the other GameplayKit and SpriteKit custom classes to implement the game mechanics

enum CollisionTypes: UInt32 {
    case Turret = 1
    case Enemy = 2
    case Finish = 4
}

// This first one was really, really helpful
/// - Attributions: https://blog.lukasjoswiak.com/gameplaykit-for-beginners-part-1/
/// - Attributions: http://untamed.wild-refuge.net/rmxpresources.php?characters
/// - Attributions: Krasi Wasilev ( http://freegameassets.blogspot.com)
/// - Attributions: https://cdn3.iconfinder.com/data/icons/buttons/512/Icon_3-512.png
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Properties
    var viewController: UIViewController?
    let gameInfo = GameInfo.sharedInstance
    
    // Sizing and location properties
    var grid = SKNode()     // The grid
    let gridHidden = true   // for hiding the grid
    var gridRows = 15       // Number of rows in the grid
    var gridColumns = 27    // Number of columns in the grid
    var xOffset: Double!    // x offset to adjust the grid
    var yOffset: Double!    // y offset to adjust the grid
    let gridWidthProportion = 1.0
    let gridHeightProportion = 1.0
    
    var usableHeight: Double! {
        didSet {boxSize = usableHeight / Double(currentLevel.mapLayout.count)}
    }
    
    var width: CGFloat!
    var height: CGFloat!
    var boxSize: Double!    // Size of a box on the grid
    var gridStart: CGPoint!
    
    // Current level
    var currentLevel: Level!
    var levelName: String?
    var difficulty: String?
    
    // GKGridGraphs to organize various sprites
    var pathGraph: GKGridGraph!
    var turretLocationsGraph: GKGridGraph!
    var layout = [[GKEntity]]()
    
    // Various sprite scaling sizes
    let turretScale: Double = 1.4
    
    // Game state properties
    var wave = 1
    var waveInProgress = false
    var gameOver = false
    
    var playNode: SKNode!       // Play button
    var moneyNode: SKNode!      // Money node
    var livesNode: SKNode!      // Lives node
    var currentMoney: Int! {
        didSet{(moneyNode.childNodeWithName("money") as! SKLabelNode).text = "$\(currentMoney)"}
    }
    var currentLives: Int! {
        didSet{(livesNode.childNodeWithName("lives") as! SKLabelNode).text = "Lives: \(currentLives)"}
    }
    
    // Node containers
    var turrets = [Turret]()  // Array of Turret objects
    var enemies = [Enemy]() // Array of Enemy objects
    
    // Enemy path guides
    var enemyStart: int2!
    var enemyEnd: int2!
    
    let parentNode = "turretNode"
    var previousTime: CFTimeInterval?
    
    // MARK: - Life-cycle
    override func didMoveToView(view: SKView) {
        if let levelName = levelName, difficulty = difficulty {
            currentLevel = Level(name: levelName, difficulty: difficulty)
        } else {
            currentLevel = Level(name: "park2", difficulty: "easy")
        }
        
        gridRows = Int(currentLevel.rows)
        gridColumns = Int(currentLevel.cols)
        
        let background = SKSpriteNode(imageNamed: currentLevel.backgroundName)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = CGSize(width: size.width, height: size.height)
        background.blendMode = .Replace
        background.zPosition = -100
        addChild(background)
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        createGrid()
        
        enemyStart = currentLevel.enemyStart
        enemyEnd = currentLevel.baseLocation
        print("enemyStart: \(enemyStart)")
        print("enemyEnd: \(enemyEnd)")
        print("Total waves on this map: \(currentLevel.totalWaves)")
        
        pathGraph = createEnemyPathGraph()
        turretLocationsGraph = createTurretLocationsGraph()
        
        placeDefaultTerrain()
        createUIElements()
    }
    
    func gameOver(outcome: String) {
        gameOver = true
        paused = true
        
        let endGameScreen = createEndGameOverlay()
        let x = endGameScreen.position.x
        let y = endGameScreen.position.y
        
        let gameOverNode = SKNode()
        let gameOverLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
        gameOverLabel.fontSize = 50
        
        let messageNode = SKNode()
        let messageLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
        gameOverLabel.fontSize = 25
        
        let mainMenuNode = SKNode()
        let mainMenuLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
        mainMenuLabel.text = "Tap to return to the main menu."
        
        if outcome == "win" {
            print("All waves defeated\nPlayer wins!")
            gameOverLabel.text = "YOU WIN!"
            messageLabel.text = "Your ice cream is safe for another day."
        } else {
            print("Game over\nPlayer loses...")
            gameOverLabel.text = "GAME OVER"
            messageLabel.text = "The monsters ate all of your ice cream..."
        }
        
        gameOverLabel.fontColor = UIColor.whiteColor()
        gameOverLabel.horizontalAlignmentMode = .Center
        gameOverNode.addChild(gameOverLabel)
        gameOverNode.position = CGPointMake(x, y + y * 0.1)
        gameOverNode.zPosition = 101
        
        messageLabel.fontColor = UIColor.whiteColor()
        messageLabel.horizontalAlignmentMode = .Center
        messageNode.addChild(messageLabel)
        messageNode.position = CGPointMake(x, y - y * 0.1)
        messageNode.zPosition = 101
        
        mainMenuLabel.fontColor = UIColor.whiteColor()
        mainMenuLabel.horizontalAlignmentMode = .Center
        mainMenuNode.addChild(mainMenuLabel)
        mainMenuNode.position = CGPointMake(x, y - y * 0.2)
        mainMenuNode.zPosition = 101
        
        addChild(endGameScreen)
        addChild(gameOverNode)
        addChild(messageNode)
        addChild(mainMenuNode)
    }
    
    func createEndGameOverlay() -> SKNode {
        // Create a black overlay with alpha to barely show the background
        let node = SKNode()
        node.zPosition = 100
        let sprite = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: width, height: height))
        sprite.name = "endGameScreen"
        sprite.size = CGSize(width: size.width, height: size.height)
        sprite.alpha = 0.8
        node.addChild(sprite)
        node.position = CGPoint(x: size.width / 2, y: size.height / 2)
        return node
    }
    
    // MARK: Touch handling
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        let touch = touches.first!
        let location = touch.locationInNode(self)
        
        // If it's not a game over
        if !gameOver {
            if let coordinate = coordinateForPoint(location) {
                
                // Change this to create specific turret locations
                if layout[Int(coordinate.x)][Int(coordinate.y)].components.count <= 0 {
                    let sprite = SKSpriteNode(imageNamed: "bulletTurret")
                    createTurretAtCoordinate(coordinate, withSprite: sprite, name: "bulletTurret")
                }
            }
            
            let touchedNode = self.nodeAtPoint(location)
            if let name = touchedNode.name {
                if name == "play" && !waveInProgress && wave <= currentLevel.totalWaves {
                    print("Wave \(wave)")
                    createEnemies()
                }
            }
            if let name = touchedNode.name {
                if name == "settings" {
                    if !paused {
                        paused = true
                    }
                    self.viewController!.performSegueWithIdentifier("sceneToMainMenu", sender: self.viewController!)
                }
            }
        
        // Segue to the main menu if a tap occurs after a game over
        } else {
            self.viewController!.performSegueWithIdentifier("sceneToMainMenu", sender: self.viewController!)
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        if previousTime == nil {
            previousTime = currentTime
        }
        for turret in turrets {
            turret.updateWithDeltaTime(currentTime - previousTime!)
        }
        for enemy in enemies {
            enemy.updateWithDeltaTime(currentTime - previousTime!)
        }
    }
    
    // MARK: - Information
    func coordinateForPoint(point: CGPoint) -> int2? {
        let col = Int32(ceil((Double(point.x) - xOffset) / boxSize)) - 1
        let row = Int32(ceil((Double(point.y) - yOffset) / boxSize)) - 1
        
        if (Int(col) >= 0 && Int(col) < gridColumns && Int(row) >= 0 && Int(row) < gridRows) {
            return int2(col, row)
        } else {
            return nil
        }
    }
    
    func pointForCoordinate(coordinate: int2) -> CGPoint {
        let x = Double(coordinate.x) * boxSize + xOffset + (boxSize / 2)
        let y = Double(coordinate.y) * boxSize + yOffset + (boxSize / 2)
        
        return CGPoint(x: x, y: y)
    }
    
    // MARK: - Creation
    func createSpriteAtCoordinate(name: String, coordinate: int2, size: Double) {
        let location = pointForCoordinate(coordinate)
        createSpriteAtLocation(name, location: location, size: size)
    }
    
    func createSpriteAtLocation(name: String, location: CGPoint, size: Double) {
        let node = SKNode()
        node.zPosition = 5
        let sprite = SKSpriteNode(imageNamed: name)
        sprite.name = name
        sprite.size = CGSize(width: size, height: size)
        node.addChild(sprite)
        addChild(node)
        node.position = location
    }
    
    func createTurretLocationsGraph() -> GKGridGraph {
        let gridGraph = GKGridGraph(fromGridStartingAt: int2(0, 0), width: Int32(width), height: Int32(height), diagonalsAllowed: false)
        let mapLayout = currentLevel.mapLayout
        
        for col in 0 ..< gridColumns {
            for row in 0 ..< gridRows {
                if (mapLayout[row][col] % 10) != 0 {
                    let pathRow = currentLevel.flipRow(row)
                    let coordinate = int2(Int32(col), Int32(pathRow))
                    if let graphNode = gridGraph.nodeAtGridPosition(coordinate) {
                        gridGraph.removeNodes([graphNode])
                    }
                }
            }
        }
        
        return gridGraph
    }
    
    func createEnemyPathGraph() -> GKGridGraph {
        let gridGraph = GKGridGraph(fromGridStartingAt: int2(0, 0), width: Int32(width), height: Int32(height), diagonalsAllowed: false)
        let mapLayout = currentLevel.mapLayout
        
        for col in 0 ..< gridColumns {
            for row in 0 ..< gridRows {
                if (mapLayout[row][col] % 10) != 1 {
                    let pathRow = currentLevel.flipRow(row)
                    let coordinate = int2(Int32(col), Int32(pathRow))
                    if let graphNode = gridGraph.nodeAtGridPosition(coordinate) {
                        gridGraph.removeNodes([graphNode])
                    }
                }
            }
        }
        
        return gridGraph
    }
    
    func createTurretAtCoordinate(coordinate: int2, withSprite sprite: SKSpriteNode, name: String) {
        if let graphNode = turretLocationsGraph.nodeAtGridPosition(coordinate) {
            // Remove the node containing the new turret from the grid
            pathGraph.removeNodes([graphNode])
            
            let pathToBase = self.pathToBase()
            
            // If there is no escape path
            if pathToBase.count == 0 {
                // Add the removed node back
                pathGraph.addNodes([graphNode])
                pathGraph.connectNodeToAdjacentNodes(graphNode)
                
                // And exit the function without placing a new turret
                return
            }
            
            let position = pointForCoordinate(coordinate)
            
            let turret = Turret(gridPosition: coordinate, name: "bulletTurret")
            let node = SKNode()
            node.name = parentNode
            node.position = position
            node.zPosition = 20
            sprite.name = name
            let size = boxSize * turretScale
            sprite.size = CGSize(width: size, height: size)
            node.addChild(sprite)
            
            let radius = CGFloat(boxSize * turret.range)
            
            // Delete this later?
            let circleVision = SKShapeNode(circleOfRadius: radius)
            circleVision.strokeColor = UIColor.grayColor()
            circleVision.hidden = true
            node.addChild(circleVision)
            // -------------------------------
            
            // Physics body to be able to detect when an enemy enters a turret's range
            node.physicsBody = SKPhysicsBody(circleOfRadius: radius)
            node.physicsBody!.dynamic = false
            node.physicsBody!.categoryBitMask = CollisionTypes.Turret.rawValue
            node.physicsBody!.contactTestBitMask = CollisionTypes.Enemy.rawValue
            node.physicsBody!.collisionBitMask = 0
            
            if currentMoney - turret.cost >= 0 {
                let projectile = SKSpriteNode(color: turret.projectileColor, size: turret.projectileSize)
                let visualComponent = VisualComponent(sprite: node, projectileSprite: projectile)
                turret.addComponent(visualComponent)
                addChild(visualComponent.sprite)
                
                let firingComponent = FiringComponent(sprite: sprite, emitter: turret.emitter, damage: turret.damage, fireRate: turret.fireRate, slowTo: turret.slowTo)
                turret.addComponent(firingComponent)
                
                let moneyComponent = MoneyComponent(cost: turret.cost, value: nil)
                turret.addComponent(moneyComponent)
                
                turrets.append(turret)
                layout[Int(coordinate.x)][Int(coordinate.y)] = turret
                
                currentMoney = currentMoney - turret.cost
                
                updatePathForEntities(enemies, turret: true)
                
                print("Turret created at: \(position)")
            }
        }
    }
    
    // Will use this to place scenery later on
    func placeDefaultTerrain() {
        // placeholder
    }
    
    // MARK: - Pathfinding
    func updatePathForEntities(entities: [GKEntity], turret: Bool) {
        for entity in entities {
            if let entity = entity as? Enemy {
                let currentNode = pathGraph.nodeAtGridPosition(entity.gridPosition)!
                let endNode = pathGraph.nodeAtGridPosition(entity.endGridPosition)!
                
                var newPath = pathBetweenNodes(currentNode, node2: endNode) as! [GKGridGraphNode]
                
                if newPath.count > 0 {
                    if turret {
                        let position = newPath[1].gridPosition
                        updateEntity(entity, forPosition: position)
                        newPath.removeAtIndex(1)
                    }
                    newPath.removeAtIndex(0)
                }
                
                let movementComponent = entity.componentForClass(MovementComponent)!
                movementComponent.sprite.removeAllActions()
                movementComponent.followPath(newPath)
            }
        }
    }
    
    func updateEntity(entity: GKEntity, forPosition position: int2) {
        let entity = entity as! Enemy
        let entityPosition = entity.gridPosition
        
        let visualComponent = entity.componentForClass(VisualComponent)!
        let sprite = visualComponent.sprite
        
        let regularDifference = boxSize
        
        let difference: Double
        if entityPosition.x == position.x {
            difference = Double(pointForCoordinate(position).y - sprite.position.y)
        } else {
            difference = Double(pointForCoordinate(position).x - sprite.position.x)
        }
        
        let duration = difference / regularDifference
        
        let movementComponent = entity.componentForClass(MovementComponent)!
        movementComponent.moveToCoordinate(position, duration: duration)
    }
    
    // Returns an array of GKGraphNodes representing the path between node1 and node2
    func pathBetweenNodes(node1: GKGraphNode, node2: GKGraphNode) -> [GKGraphNode] {
        return pathGraph.findPathFromNode(node1, toNode: node2)
    }
    
    // Returns the enemy path from the spawn node to the base node
    // Should return an empty array if the path has been blocked off
    func pathToBase() -> [GKGraphNode] {
        return pathBetweenNodes(pathGraph.nodeAtGridPosition(enemyStart)!, node2: pathGraph.nodeAtGridPosition(enemyEnd)!)
    }
    
    // MARK: - Setup
    func createUIElements() {
        // Place UI buttons and details
        let borderBuffer = CGFloat(size.width * 0.03)
        createSpriteAtLocation("play", location: CGPointMake(borderBuffer, size.height - borderBuffer), size: boxSize * 1.5)
        createSpriteAtLocation("settings", location: CGPointMake(borderBuffer, borderBuffer), size: boxSize * 1.5)
        createSpriteAtCoordinate(currentLevel.baseName, coordinate: enemyEnd, size: boxSize * 2)
        
        moneyNode = SKNode()
        let moneyLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
        moneyLabel.name = "money"
        moneyLabel.fontColor = UIColor.greenColor()
        moneyLabel.horizontalAlignmentMode = .Right
        moneyNode.position = CGPointMake(size.width - borderBuffer, size.height - borderBuffer)
        moneyNode.addChild(moneyLabel)
        addChild(moneyNode)
        
        livesNode = SKNode()
        let livesLabel = SKLabelNode(fontNamed: "AmericanTypewriter")
        livesLabel.name = "lives"
        livesLabel.fontColor = UIColor.redColor()
        livesLabel.horizontalAlignmentMode = .Right
        livesLabel.position = CGPointMake(moneyNode.position.x - 100, size.height - borderBuffer)
        livesNode.addChild(livesLabel)
        addChild(livesNode)
        
        currentMoney = currentLevel.initialMoney
        currentLives = currentLevel.initialLives
    }
    
    func createGrid() {
        // An SKNode to hold all grid squares
        let grid = SKNode()
        
        // Only want to use 90% of the width and 80% of the height
        //let usableWidth = Double(size.width) * gridWidthProportion
        usableHeight = Double(size.height) * gridHeightProportion
        
        // Calculate box size
        //boxSize = usableHeight / Double(gridRows)
        //boxSize = usableHeight / 11.0
        
        // Calculate number of columns on the grid
        //gridColumns = Int(usableWidth / boxSize)
        
        width = CGFloat(gridColumns)
        height = CGFloat(gridRows)
        
        // These offsets will be used to center the grid on the screen
        xOffset = (Double(size.width) - boxSize * Double(gridColumns)) / 2.0
        yOffset = (Double(size.height) - boxSize * Double(gridRows)) / 2.0
        xOffset = xOffset + (xOffset * currentLevel.xAdjust)
        yOffset = yOffset + (yOffset * currentLevel.yAdjust)
        
        // Finally figured out how to use this loop notation!
        for col in 0 ..< gridColumns {
            let xPos = boxSize * Double(col)
            layout.append(Array(count: gridRows, repeatedValue: GKEntity()))
            
            for row in 0 ..< gridRows {
                let yPos = boxSize * Double(row)
                
                let path = UIBezierPath(rect: CGRect(x: xPos + xOffset, y: yPos + yOffset, width: boxSize, height: boxSize))
                let box = SKShapeNode()
                box.path = path.CGPath
                box.strokeColor = UIColor.grayColor()
                box.alpha = 0.3
                grid.addChild(box)
            }
        }
        
        // Add the grid to the scene
        if (!self.gridHidden) {
            addChild(grid)
        }
    }
    
    func createEnemies() {
        // Create the enemies
        let currentWave = currentLevel.waves[wave]!
        
        for i in 0 ..< currentWave[0].count {
            let type = currentWave[0][i]
            let count = currentWave[1][i]
            
            let enemyName = gameInfo.enemyNameByKey(type)
            
            for _ in 0 ..< count {
                let enemy = Enemy(gridPosition: enemyStart, endGridPosition: enemyEnd, name: enemyName)
                
                let sprite = SKSpriteNode(imageNamed: enemy.name)
                sprite.position = pointForCoordinate(enemy.gridPosition)
                sprite.size = CGSize(width: boxSize * enemy.sizeFactor, height: boxSize * enemy.sizeFactor)
                
                let visualComponent = VisualComponent(sprite: sprite, projectileSprite: nil)
                enemy.addComponent(visualComponent)
                
                let enemySprite = visualComponent.sprite as! SKSpriteNode
                visualComponent.sprite.physicsBody = SKPhysicsBody(circleOfRadius: enemySprite.size.width / 2)
                visualComponent.sprite.physicsBody!.categoryBitMask = CollisionTypes.Enemy.rawValue
                visualComponent.sprite.physicsBody!.contactTestBitMask = CollisionTypes.Turret.rawValue
                visualComponent.sprite.physicsBody!.collisionBitMask = 0
                
                let movementComponent = MovementComponent(sprite: sprite)
                enemy.addComponent(movementComponent)
                
                let hpComponent = HPComponent(hp: enemy.maxHP)
                enemy.addComponent(hpComponent)
                
                let moneyComponent = MoneyComponent(cost: nil, value: enemy.value)
                enemy.addComponent(moneyComponent)
                
                enemies.append(enemy)
            }
        }
        
        // Add the enemies to the grid
        var sequence = [SKAction]()
        
        for enemy in enemies {
            let action = SKAction.runBlock() { [unowned self] in
                let movementComponent = enemy.componentForClass(MovementComponent)!
                self.addChild(movementComponent.sprite)
                
                let visualComponent = enemy.componentForClass(VisualComponent)!
                let hpBar = self.createHPBar(enemy)
                visualComponent.sprite.addChild(hpBar)
                
                // Updates the current enemy's path
                self.updatePathForEntities([enemy], turret: false)
            }
            
            var delayVal: NSTimeInterval = 1.5
            if enemy.type == "boss" {
                delayVal = 3
            }
            let delay = SKAction.waitForDuration(delayVal)
            
            sequence += [action, delay]
        }
        
        runAction(SKAction.sequence(sequence))
    }
    
    func enemyForSprite(sprite: SKNode) -> Enemy? {
        for enemy in enemies {
            let enemySprite = enemy.componentForClass(VisualComponent)!.sprite
            if enemySprite == sprite {
                return enemy
            }
        }
        
        return nil
    }
    
    func updateEnemyHP(enemy: Enemy) {
        let enemyNode = enemy.componentForClass(VisualComponent)!.sprite
        if let hpBar = enemyNode.childNodeWithName("HPBar") {
            let newHPBar = createHPBar(enemy)
            
            enemyNode.removeChildrenInArray([hpBar])
            let hpComponent = enemy.componentForClass(HPComponent)!
            
            if hpComponent.hp > 0 {
                enemyNode.addChild(newHPBar)
            } else {
                removeEnemy(enemy, awardCash: true)
            }
        }
    }
    
    func createHPBar(entity: GKEntity) -> SKSpriteNode {
        let visualComponent = entity.componentForClass(VisualComponent)!
        
        let frame = visualComponent.sprite.frame
        let newHPBar = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: frame.width, height: 1))
        
        if let hpComponent = entity.componentForClass(HPComponent) {
            let maxHP = hpComponent.maxHP
            let hp = hpComponent.hp
            
            var remainingHP = frame.width * CGFloat(hp / maxHP)
            if remainingHP < 0 {
                remainingHP = 0
            }
            
            newHPBar.size = CGSize(width: remainingHP, height: 1)
            newHPBar.name = "HPBar"
            newHPBar.position = CGPoint(x: 0, y: -1 * frame.height / 2 - 7)
        }
        return newHPBar
    }
    
    func removeEnemy(enemy: Enemy, awardCash: Bool) {
        var index = 0
        
        for iEnemy in enemies {
            if iEnemy == enemy {
                let node = enemy.componentForClass(VisualComponent)!.sprite
                
                // Enemy death animation (change later maybe)
                let action = SKAction.scaleTo(0, duration: 2)
                
                let enemyValue = enemy.componentForClass(MoneyComponent)!.value
                
                node.removeAllActions()
                node.runAction(action)
                
                // Remove the enemy from the enemies array
                self.enemies.removeAtIndex(index)
                
                // Award the enemies value to the player
                if awardCash {
                    currentMoney = currentMoney + enemyValue!
                }
                break
            }
            index++
        }
        if enemies.count == 0 {
            print("Wave \(wave) completed")
            waveInProgress = false
            if wave == currentLevel.totalWaves && !gameOver {
                self.gameOver("win")
            }
            wave += 1
        }
    }
    
    func enemyHitBase(enemy: Enemy) {
        removeEnemy(enemy, awardCash: false)
        currentLives = currentLives - enemy.damage
        if currentLives <= 0 && !gameOver {
            self.gameOver("loss")
        }
    }
    
    // MARK: Firing component handlers
    func fireProjectileFromEntity(entity: GKEntity, towardsEnemy enemy: Enemy, angle: CGFloat) {
        let enemyVisualComponent = enemy.componentForClass(VisualComponent)!
        let enemyPosition = enemyVisualComponent.sprite.position
        
        let visualComponent = entity.componentForClass(VisualComponent)!
        let spritePosition = visualComponent.sprite.position
        
        let projectileSprite = visualComponent.projectileSprite!
        let projectile = projectileSprite.copy() as! SKSpriteNode
        projectile.position = spritePosition
        projectile.zPosition = 18
        projectile.zRotation = angle
        addChild(projectile)
        
        let firingComponent = entity.componentForClass(FiringComponent)!
        if let emitter = firingComponent.emitter {
            emitter.zRotation = angle
        }
        
        let duration: NSTimeInterval!
        if Int(Double(spritePosition.x) * 1000) % 2 == 0 {
            duration = 0.2
        } else {
            duration = 0.27
        }
        
        let trajectory = SKAction.moveTo(enemyPosition, duration: duration)
        projectile.runAction(trajectory) { [unowned self] in
            self.removeChildrenInArray([projectile])
        }
    }
    
    func entityDidBeginFiring(entity: GKEntity, towardsEnemy enemy: Enemy, angle: CGFloat) {
        // for later
    }
    
    func entityDidFinishFiring(entity: GKEntity) {
        // for later
    }
    
    func contact(nodeA: SKNode, nodeB: SKNode, entered: Bool) {
        var turret: Turret!
        var enemy: Enemy?
        var coordinate: int2!
        
        if nodeA.name == parentNode {
            coordinate = coordinateForPoint(nodeA.position)
            enemy = enemyForSprite(nodeB)
        } else if nodeB.name == parentNode {
            coordinate = coordinateForPoint(nodeB.position)
            enemy = enemyForSprite(nodeA)
        }
        
        turret = layout[Int(coordinate.x)][Int(coordinate.y)] as! Turret
        
        if let enemy = enemy {
            let firingComponent = turret.componentForClass(FiringComponent)!
            
            if entered {
                firingComponent.enemyEnteredTurretRange(enemy)
            } else {
                firingComponent.enemyExitedTurretRange(enemy)
            }
        }
    }
    
    // MARK: - SKPhysicsContactDelegate
    func didBeginContact(contact: SKPhysicsContact) {
        self.contact(contact.bodyA.node!, nodeB: contact.bodyB.node!, entered: true)
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        self.contact(contact.bodyA.node!, nodeB: contact.bodyB.node!, entered: false)
    }
}
