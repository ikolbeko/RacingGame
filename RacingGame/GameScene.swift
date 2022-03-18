//
//  GameScene.swift
//  RacingGame
//
//  Created by Илья Колбеко on 17.03.22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var player: SKSpriteNode!
    var road1: SKSpriteNode!
    var road2: SKSpriteNode!

    override func didMove(to view: SKView) {
        // Set road
        road1 = SKSpriteNode(imageNamed: "road")
        road1.size = self.frame.size
        road1.anchorPoint = CGPoint(x: 0, y: 0)
        road1.position = CGPoint(x: 0, y: 0)
        addChild(road1)
        
        road2 = SKSpriteNode(imageNamed: "road")
        road2.size = self.frame.size
        road2.anchorPoint = CGPoint(x: 0, y: 0)
        road2.position = CGPoint(x: 0, y: road1.size.height)
        addChild(road2)
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveScene()
    }
    
    func moveScene() {
        //make road move
        road1.position = CGPoint(x: road1.position.x, y: road1.position.y - 10)
        road2.position = CGPoint(x: road2.position.x, y: road2.position.y - 10)
        
        //check road position
        if road1.position.y < -road1.size.height {
            road1.position = CGPoint(x: road1.position.x, y: road2.position.y + road2.size.height)
        }
        
        if road2.position.y < -road2.size.height {
            road2.position = CGPoint(x: road2.position.x, y: road1.position.y + road1.size.height)
        }
    }
}
