//
//  GameScene.swift
//  RacingGame
//
//  Created by Илья Колбеко on 17.03.22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let gameSettings = Settings.sharedInstance
    var player = SKSpriteNode()
    var road1 = SKSpriteNode(imageNamed: "road")
    var road2 = SKSpriteNode(imageNamed: "road")
    var metricLabel = SKLabelNode(text: "Score: 0")
    var meters = 0
    lazy var gameSpeed = level
    var carAtRight = false
    var carAtLeft = true
    var score = 0 {
        didSet {
            metricLabel.text = "Score: \(score)"
        }
    }
    var level: Double {
        switch gameSettings.level {
        case "easy": return 10
        case "medium": return 15
        case "hard": return 20
        default: return 5
        }
    }
    
    
    let carArray = Settings.sharedInstance.carArray
    
    
    var gameOverPicture = SKSpriteNode(imageNamed: "gameOver")
    
    enum GameStatus {
        case running
        case over
    }
    
    var gameStatus: GameStatus = .running
    
    override func didMove(to view: SKView) {
        
        // Set Physics
        self.physicsBody = SKPhysicsBody (edgeLoopFrom: self.frame)
        self.physicsWorld.contactDelegate = self
        
        // Set Road
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
        
        player = SKSpriteNode(imageNamed: gameSettings.playerCar)
        player.zPosition = 2
        
        // Phusic Configuration
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody? .allowsRotation = false
        player.physicsBody? .categoryBitMask = playerCategory
        player.physicsBody? .contactTestBitMask = traficCarCategory
        
        // Add Score Label
        metricLabel.verticalAlignmentMode = .top
        metricLabel.horizontalAlignmentMode = .center
        metricLabel.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.95)
        metricLabel.fontSize = 30
        metricLabel.fontName = "Rockwell-Bold"
        metricLabel.fontColor = .black
        metricLabel.zPosition = 5
        addChild(metricLabel)
        
        // Add player
        addChild(player)
        startGame()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if gameStatus != .over {
            moveScene()
        }
        
        if gameStatus == .running {
            meters += 1
            
            if meters == 100 {
                score += 1
                meters = 0
                gameSpeed *= 1.01
            }
        }
    }
    
    func moveScene() {
        // Make road move
        road1.position = CGPoint(x: road1.position.x, y: road1.position.y - (gameSpeed * 0.8))
        road2.position = CGPoint(x: road2.position.x, y: road2.position.y - (gameSpeed * 0.8))
        
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
                carSprite.position = CGPoint(x: carSprite.position.x, y: carSprite.position.y - (gameSpeed * 0.5))
                
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
            
            if gameStatus == .over {
                if let view = self.view {
                    let menuScene = MenuScene (size: view.bounds.size)
                    menuScene.scaleMode = .aspectFill
                    view.presentScene(menuScene, transition: SKTransition.doorsCloseHorizontal(withDuration: TimeInterval(2)))
                }
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
        let carTexture = SKTexture (imageNamed: carArray[Int.random(in: 0...carArray.endIndex - 1)])
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
        let waitAct = SKAction.wait(forDuration: Double.random(in: 3.0...5.0), withRange: 1.1)
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
        
        if gameSettings.highScore < score {
            gameSettings.highScore = score
            UserDefaults.standard.set(gameSettings.highScore, forKey: "GameHighScore")
        }
        
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
