//
//  GameScene.swift
//  Space
//
//  Created by Daksh Chaudhary on 18/04/24.
//

import SpriteKit
import GameplayKit
enum CollisionType: UInt32 {
    case player = 1
    case playerWeapon = 2
    case enemy = 4
    case enemyWeapon = 8
}

class GameScene: SKScene {
    let player = SKSpriteNode(imageNamed: "player")
    let waves = Bundle.main.decode([Wave].self, from: "waves.json")
    let enemyTypes = Bundle.main.decode([EnemyType].self,from: "enemy-types.json")
    var isPlayerAlive = true
    var levelNumber = 0
    var waveNumber = 0
    let positions = Array(stride(from: -320, through: 320, by: 80))
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        if let particles = SKEmitterNode(fileNamed: "MyParticle"){
            particles.position = CGPoint(x: 1000, y: 0)
            particles.advanceSimulationTime(60)
            particles.zPosition = -1
            addChild(particles)
            
        }
        player.name = "player"
        player.position.x = frame.minX + 75
        player.zPosition = 1
        addChild(player)
        
        player.physicsBody = SKPhysicsBody(texture:player.texture!, size: player.texture!.size())
        player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player.physicsBody?.categoryBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
        player.physicsBody?.contactTestBitMask = CollisionType.enemy.rawValue | CollisionType.enemyWeapon.rawValue
        player.physicsBody?.isDynamic =  false
        
        
    }
    override func update(_ currentTime: TimeInterval) {
       // if let accelerometerData = motionManager.accelerometerData {
           // player.position.y += CGFloat(accelerometerData.acceleration.x * 50)
            
            if player.position.y < frame.minY {
                player.position.y = frame.minY
            } else if player.position.y > frame.maxY {
                player.position.y = frame.maxY
            }
        
        
        for child in children {
            if child.frame.maxX < 0 {
                if !frame.intersects(child.frame) {
                    child.removeFromParent()
                }
            }
        }
        
        let activeEnemies = children.compactMap { $0 as? EnemyNode }
        
        if activeEnemies.isEmpty {
            createWave()
        }
        
        for enemy in activeEnemies {
            guard frame.intersects(enemy.frame) else { continue }

            if enemy.lastFireTime + 1 < currentTime {
                enemy.lastFireTime = currentTime

                if Int.random(in: 0...6) == 0 {
                    enemy.fire()
                }
            }
        }
        
        func createWave() {
            guard isPlayerAlive else { return }
            
            if waveNumber == waves.count {
                levelNumber += 1
                waveNumber = 0
            }
            let currentWave = waves[waveNumber]
            waveNumber += 1
            
            let maximumEnemyType = min(enemyTypes.count, levelNumber + 1)
            let enemyType = Int.random(in: 0 ..< maximumEnemyType)
            
            let enemyOffsetX: CGFloat = 100
            let enemyStartX = 600
            
            if currentWave.enemies.isEmpty {
                
                for (index, position) in positions.shuffled().enumerated() {
                    
                    let enemy = EnemyNode(type: enemyTypes[enemyType], startPosition: CGPoint(x: enemyStartX, y: position), offset: enemyOffsetX * CGFloat(index * 3), movestraight: true)
                    addChild(enemy)
                }
            } else {
                
                for enemy in currentWave.enemies {
                    
                    let node = EnemyNode(type: enemyTypes[enemyType], startPosition: CGPoint(x: enemyStartX, y: positions[enemy.position]), offset: enemyOffsetX * enemy.xoffset, movestraight: enemy.moveStraight)
                    addChild(node)
                }
            }
        }
        
        func gameOver() {
            isPlayerAlive = false
            
            if let explosion = SKEmitterNode(fileNamed: "Explosion") {
                explosion.position = player.position
                addChild(explosion)
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            addChild(gameOver)
        }
    }}
