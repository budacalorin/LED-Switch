//
//  GameViewController.swift
//  LED Switch
//
//  Created by Lorin Budaca on 11.04.2022.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var level: Level!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                guard scene.configure(level: level) else {
                    return
                }
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                scene.isUserInteractionEnabled = true
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
