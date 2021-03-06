//
//  GameViewController.swift
//  LED Switch
//
//  Created by Lorin Budaca on 11.04.2022.
//

import Combine
import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var level: Level!
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                guard scene.configure(level: level) else {
                    return
                }
                
                scene.dismiss
                    .sink { [weak self] in
                        self?.dismiss(animated: true)
                    }
                    .store(in: &cancellables)
                
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
        
        setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        [.bottom]
    }
}
