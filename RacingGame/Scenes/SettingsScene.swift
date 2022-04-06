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
    var level = SKLabelNode()
    var levelText: String {
        switch Settings.sharedInstance.level {
        case .easy:
            return NSLocalizedString("Easy", comment: "Easy")
        case .medium:
            return NSLocalizedString("Medium", comment: "Medium")
        case .hard:
            return NSLocalizedString("Hard", comment: "Hard")
        }
    }
    let backToMenuText = NSLocalizedString("Back", comment: "backToMenuText")

    
    override func didMove(to view: SKView) {
        // Back to menu Label
        let back = SKLabelNode(text: backToMenuText)
        back.name = "back"
        back.fontSize = 35
        back.fontName = "Rockwell-Bold"
        back.fontColor = .gray
        
        // Level Label
        level.removeFromParent()
        level = SKLabelNode(text: levelText)
        level.name = "level"
        level.fontSize = 40
        level.fontName = "Rockwell-Bold"
        level.fontColor = .red
        
        // Player Car
        playerCar.removeFromParent()
        playerCar = SKSpriteNode(imageNamed: gameSettings.playerCar)
        playerCar.name = "playerCar"
        playerCar.zPosition = 1
        
        // Set Position
        back.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.1)
        level.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.7)
        playerCar.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.45)

        addChild(back)
        addChild(level)
        addChild(playerCar)
    }
    
    override func update(_ currentTime: TimeInterval) {
        level.text = levelText
        playerCar.texture = SKTexture(imageNamed: gameSettings.playerCar)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let touchLocation = touch.location(in: self)
            if atPoint(touchLocation).name == "level" {
                gameSettings.changeLevel()
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
