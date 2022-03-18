//
//  GameScene.swift
//  RacingGame
//
//  Created by Илья Колбеко on 17.03.22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player = SKSpriteNode(imageNamed: "whiteCar")
    var road1 = SKSpriteNode(imageNamed: "road")
    var road2 = SKSpriteNode(imageNamed: "road")
    var carAtRight = false
    var carAtLeft = true
    
    var gameOverPicture = SKSpriteNode(imageNamed: "gameOver")
    
    enum GameStatus {
        case running
        case over
    }
    
    var gameStatus: GameStatus = .running
    
    override func didMove(to view: SKView) {
        
        // Set physics
        self.physicsBody = SKPhysicsBody (edgeLoopFrom: self.frame)
        self.physicsWorld.contactDelegate = self
        
        // Set road
        road1.size = self.frame.size
        road1.zPosition = 1
        road1.anchorPoint = CGPoint(x: 0, y: 0)
        road1.position = CGPoint(x: 0, y: 0)
        addChild(road1)
        
        road2.size = self.frame.size
        road1.zPosition = 1
        road2.anchorPoint = CGPoint(x: 0, y: 0)
        road2.position = CGPoint(x: 0, y: road1.size.height)
        addChild(road2)
        
        player.zPosition = 2
        
        // Phusic configuration
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody? .allowsRotation = false
        player.physicsBody? .categoryBitMask = playerCategory
        player.physicsBody? .contactTestBitMask = traficCarCategory
        
        // Add player
        addChild(player)
        startGame()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameStatus != .over {
            moveScene()
        }
    }
    
    func moveScene() {
        // Make road move
        road1.position = CGPoint(x: road1.position.x, y: road1.position.y - 5)
        road2.position = CGPoint(x: road2.position.x, y: road2.position.y - 5)
        
        // Check road position
        if road1.position.y < -road1.size.height {
            road1.position = CGPoint(x: road1.position.x, y: road2.position.y + road2.size.height)
        }
        
        if road2.position.y < -road2.size.height {
            road2.position = CGPoint(x: road2.position.x, y: road1.position.y + road1.size.height)
        }
        
        // Move trafic
        for carNode in self.children where carNode.name == "car" {
            if let carSprite = carNode as? SKSpriteNode {
                carSprite.position = CGPoint(x: carSprite.position.x, y: carSprite.position.y - 1)
                
                if carSprite.position.y < -carSprite.size.height * 0.5 {
                    carSprite.removeFromParent()
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            if carAtLeft {
                player.position = CGPoint(x: self.size.width * 0.65, y: player.position.y) // Right position
                carAtLeft = false
                carAtRight = true
            } else {
                player.position = CGPoint(x: self.size.width * 0.35, y: player.position.y) // Left position
                carAtLeft = true
                carAtRight = false
            }
        }
    }
    
    func startGame() {
        player.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.08)
        startCreateCar()
        removeTrafic()
    }
    
    // MARK: Trafic
    func addCar(position: CGPoint) {
        let carTexture = SKTexture (imageNamed: "myCar")
        let car = SKSpriteNode(texture: carTexture)
        car.name = "car"
        car.position = position
        car.zPosition = 3
        
        car.physicsBody = SKPhysicsBody(texture: carTexture, size: car.size)
        car.physicsBody?.isDynamic = false
        car.physicsBody?.categoryBitMask = traficCarCategory
        
        addChild(car)
    }
    
    func createRandomCar() {
        let position = [
            CGPoint(x: self.size.width * 0.65, y: self.size.height + 150),
            CGPoint(x: self.size.width * 0.35, y: self.size.height + 150)
        ]
        let carSide = Int.random(in: 0...1)
        addCar(position: position[carSide])
    }
    
    func startCreateCar() {
        let waitAct = SKAction.wait(forDuration: 6.5, withRange: 1.0)
        let generateCarAct = SKAction.run {
            self.createRandomCar()
        }
        run(SKAction.repeatForever(SKAction.sequence([waitAct, generateCarAct])), withKey: "createCar")
    }
    
    func stopCreateCar() {
        self.removeAction(forKey: "createCar")
    }
    
    func removeTrafic() {
        for car in self.children where car.name == "car" {
            car.removeFromParent()
        }
    }
    
    
    // MARK: Game Over
    
    func gameOver() {
        
        let explosion = SKEmitterNode(fileNamed: "Explosion")
        if let explosion = explosion {
            explosion.position = player.position
            explosion.zPosition = 4
            addChild(explosion)
        }
        
        player.removeFromParent()
        gameStatus = .over
        stopCreateCar()
        
        isUserInteractionEnabled = false
        
        gameOverPicture.zPosition = 4
        addChild(gameOverPicture)
        
        gameOverPicture.position = CGPoint(x: self.size.width * 0.5, y: self.size.height)
        
        gameOverPicture.run(SKAction.move(by: CGVector(dx:0, dy: -self.size.height * 0.5), duration: 0.5), completion: {
            self.isUserInteractionEnabled = true
        })
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if gameStatus != .running { return }
        
        var bodyA: SKPhysicsBody
        var bodyB: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            bodyA = contact.bodyA
            bodyB = contact.bodyB
        } else {
            bodyA = contact.bodyB
            bodyB = contact.bodyA
        }
        
        if (bodyA.categoryBitMask == playerCategory && bodyB.categoryBitMask == traficCarCategory) {
            gameOver()
        }
    }
}

let playerCategory: UInt32 = 0x1 << 0
let traficCarCategory: UInt32 = 0x1 << 1
