//
//  GameViewController.swift
//  RacingGame
//
//  Created by Илья Колбеко on 17.03.22.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = MenuScene (size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = false
            view.showsNodeCount = false
        }
        
        //        if let view = self.view as! SKView? {
        //            let scene = GameScene (size: view.bounds.size)
        //            scene.scaleMode = .aspectFill
        //            view.presentScene(scene)
        //            view.ignoresSiblingOrder = true
        //            view.showsFPS = false
        //            view.showsNodeCount = false
        //        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
