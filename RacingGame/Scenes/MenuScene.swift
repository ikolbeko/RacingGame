//
//  MenuScene.swift
//  RacingGame
//
//  Created by Илья Колбеко on 18.03.22.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    let gameSettings = Settings.sharedInstance
    
    override func didMove(to view: SKView) {
        gameSettings.highScore = UserDefaults.standard.integer(forKey: "GameHighScore")
        
        // Start Game Label
        let startGame = SKLabelNode(text: "Start Game")
        startGame.name = "startGame"
        startGame.fontSize = 45
        startGame.fontName = "Rockwell-Bold"
        startGame.fontColor = .red
        
        // Settings Label
        let settings = SKLabelNode(text: "Settings")
        settings.name = "settings"
        settings.fontSize = 35
        settings.fontName = "Rockwell-Bold"
        settings.fontColor = .gray
        
        // Best Score Label
        let bestScore = SKLabelNode(text: "Best Score: \(gameSettings.highScore)")
        bestScore.fontName = "Rockwell-Bold"
        bestScore.fontColor = .gray
        bestScore.fontSize = 25

        // Set Label Position
        startGame.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.6)
        settings.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        bestScore.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.4)
        
        addChild(startGame)
        addChild(settings)
        addChild(bestScore)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let touchLocation = touch.location(in: self)
            if atPoint(touchLocation).name == "startGame" {
                if let view = self.view {
                    let scene = GameScene (size: view.bounds.size)
                    scene.scaleMode = .aspectFill
                    view.presentScene(scene)
                    view.ignoresSiblingOrder = true
                    view.showsFPS = false
                    view.showsNodeCount = false
                }
            }
            
            if atPoint(touchLocation).name == "settings" {
                if let view = self.view {
                    let settingsScene = SettingsScene (size: view.bounds.size)
                    settingsScene.scaleMode = .aspectFill
                    view.presentScene(settingsScene, transition: SKTransition.crossFade(withDuration: TimeInterval(0.5)))
                }
            }
            
        }
    }
}
