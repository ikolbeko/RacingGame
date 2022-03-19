//
//  SettingsScene.swift
//  RacingGame
//
//  Created by Илья Колбеко on 19.03.22.
//

import Foundation
import SpriteKit

class SettingsScene: SKScene {
    let gameSettings = Settings.sharedInstance
    var playerCar = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        gameSettings.highScore = UserDefaults().integer(forKey: "GameHighScore")
        
        // Back to menu Label
        let back = SKLabelNode(text: "Back")
        back.name = "back"
        back.fontSize = 35
        back.fontName = "Rockwell-Bold"
        back.fontColor = .gray

        // Set Label Position
        back.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.1)

        addChild(back)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Level Label
        let level = SKLabelNode(text: "Hard")
        level.name = "level"
        level.fontSize = 40
        level.fontName = "Rockwell-Bold"
        level.fontColor = .red
        
        // Player Car
        playerCar.removeFromParent()
        playerCar = SKSpriteNode(imageNamed: gameSettings.playerCar)
        playerCar.name = "playerCar"
        playerCar.zPosition = 1
        
        level.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        playerCar.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.45)
        
        addChild(level)
        addChild(playerCar)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let touchLocation = touch.location(in: self)
            if atPoint(touchLocation).name == "level" {
                print("level")
            }
            
            if atPoint(touchLocation).name == "playerCar" {
                gameSettings.changePlayerCar()
            }
            
            if atPoint(touchLocation).name == "back" {
                if let view = self.view {
                    let menuScene = MenuScene (size: view.bounds.size)
                    menuScene.scaleMode = .aspectFill
                    view.presentScene(menuScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
                }
            }
        }
    }
}
