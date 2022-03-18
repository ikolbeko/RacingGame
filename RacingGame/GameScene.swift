//
//  GameScene.swift
//  RacingGame
//
//  Created by Илья Колбеко on 17.03.22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player = SKSpriteNode(imageNamed: "whiteCar")
    var road1 = SKSpriteNode(imageNamed: "road")
    var road2 = SKSpriteNode(imageNamed: "road")
    var carAtRight = false
    var carAtLeft = true
    
    enum GameStatus {
        case idle
        case running
        case over
    }

    var gameStatus: GameStatus = .idle
    
    override func didMove(to view: SKView) {
        
        // Set road
        road1.size = self.frame.size
        road1.anchorPoint = CGPoint(x: 0, y: 0)
        road1.position = CGPoint(x: 0, y: 0)
        addChild(road1)
        
        road2.size = self.frame.size
        road2.anchorPoint = CGPoint(x: 0, y: 0)
        road2.position = CGPoint(x: 0, y: road1.size.height)
        addChild(road2)
        
        // Add player
        addChild(player)
        shuffle()
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveScene()
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            if carAtLeft {
                player.position = CGPoint(x: self.size.width * 0.65, y: self.size.height * 0.15) // Right position
                carAtLeft = false
                carAtRight = true
            } else {
                player.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.15) // Left position
                carAtLeft = true
                carAtRight = false
            }
        }
    }
    
    func shuffle() {
        gameStatus = .idle
        player.position = CGPoint(x: self.size.width * 0.35, y: self.size.height * 0.15)
    }
    
    func startGame() {
        gameStatus = .running
    }
    
    func gameOver() {
        gameStatus = .over
    }
}
