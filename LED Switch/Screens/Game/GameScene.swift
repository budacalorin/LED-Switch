//
//  GameScene.swift
//  LED Switch
//
//  Created by Lorin Budaca on 11.04.2022.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    
    private var level: Level!
    private var player: AVAudioPlayer!
    
    private var redSliderNode: SKSpriteNode!
    private var greenSliderNode: SKSpriteNode!
    private var blueSliderNode: SKSpriteNode!
    private var redNode: SKSpriteNode!
    private var greenNode: SKSpriteNode!
    private var blueNode: SKSpriteNode!
    private var backgroundNode: SKSpriteNode!
    private var playGameContainerNode: SKSpriteNode!
    private var remainingTimeLabel: SKLabelNode!
    private var currentScoreLabel: SKLabelNode!
    private var colorToMatchNode: SKSpriteNode!
    private var developerRecordContainer: SKSpriteNode!
    
    private var isPlaying = false
    private var matchColorDeadline: TimeInterval? {
        guard let currentIndex = currentIndex else {
            return nil
        }
        return level.colorTargets[currentIndex].seconds
    }
    private var colorToMatch: UIColor? {
        guard let currentIndex = currentIndex else {
            return nil
        }
        return level.colorTargets[currentIndex].color
    }
    private var currentIndex: Int?
    private var currentScore = 0
    
    override func didMove(to view: SKView) {
        redSliderNode = (childNode(withName: "//RedSliderNode") as! SKSpriteNode)
        greenSliderNode = (childNode(withName: "//GreenSliderNode") as! SKSpriteNode)
        blueSliderNode = (childNode(withName: "//BlueSliderNode") as! SKSpriteNode)
        redNode = (childNode(withName: "//RedNode") as! SKSpriteNode)
        greenNode = (childNode(withName: "//GreenNode") as! SKSpriteNode)
        blueNode = (childNode(withName: "//BlueNode") as! SKSpriteNode)
        backgroundNode = (childNode(withName: "//BackgroundNode") as! SKSpriteNode)
        playGameContainerNode = (childNode(withName: "//PlayGameContainer") as! SKSpriteNode)
        currentScoreLabel = (childNode(withName: "//CurrentScoreLabel") as! SKLabelNode)
        remainingTimeLabel = (childNode(withName: "//RemainingTimeLabel") as! SKLabelNode)
        colorToMatchNode = (childNode(withName: "//ColorToMatch") as! SKSpriteNode)
        developerRecordContainer = ((childNode(withName: "//RecordContainer")) as! SKSpriteNode)
    }
    
    func configure(level: Level) -> Bool {
        self.level = level
        
        guard let player = AVAudioPlayer(from: level.track) else {
            return false
        }
        self.player = player
        self.player.prepareToPlay()
        self.player.delegate = self
        
        guard !level.colorTargets.isEmpty else {
            return false
        }
        currentIndex = 0
        
        return true
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateUI()
        
        if isPlaying {
            guard let matchColorDeadline = matchColorDeadline else {
                return
            }
            if player.currentTime > matchColorDeadline {
                if isCloseToColor() {
                    increaseScore()
                }
                increaseIndex()
            }
        }
    }
}

// MARK: - Update UI
extension GameScene {
    private func updateUI() {
        updateBackgroundColor()
        updateRemainingTimeLabel()
        updateCurrentScoreLabel()
        updateCurrentColorNode()
    }
    
    private func updateRemainingTimeLabel() {
        remainingTimeLabel.isHidden = matchColorDeadline == nil
        guard let matchColorDeadline = matchColorDeadline else {
            return
        }
        
        let remainingTime = matchColorDeadline - player.currentTime
        remainingTimeLabel.text = String(format: "%.2f", remainingTime)
    }
    
    private func updateCurrentScoreLabel() {
        currentScoreLabel.text = "\(currentScore)"
    }
    
    private func updateBackgroundColor() {
        backgroundNode.color = getCurrentSelectedColor()
    }
    
    private func updateCurrentColorNode() {
        guard let colorToMatch = colorToMatch else {
            return
        }
        colorToMatchNode.color = colorToMatch
    }
}

// MARK: - Touches
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        processTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        processTouches(touches)
    }
    
    private func processTouches(_ touches: Set<UITouch>) {
        touches.forEach { touch in
            let location = touch.location(in: self)
            let touchedNodes = nodes(at: location)
            if touchedNodes.contains(redNode) {
                redSliderNode.position.y = touch.location(in: redNode).y.cappedBy(-redNode.size.height/2, redNode.size.height/2)
            }
            if touchedNodes.contains(greenNode) {
                greenSliderNode.position.y = touch.location(in: greenNode).y.cappedBy(-greenNode.size.height/2, greenNode.size.height/2)
            }
            if touchedNodes.contains(blueNode) {
                blueSliderNode.position.y = touch.location(in: blueNode).y.cappedBy(-blueNode.size.height/2, blueNode.size.height/2)
            }
            if touchedNodes.contains(playGameContainerNode) {
                start()
            }
            if touchedNodes.contains(developerRecordContainer) {
                print(player.currentTime)
            }
        }
    }
}

// MARK: Game logic
extension GameScene {
    private func start() {
        isPlaying = true
        playGameContainerNode.isHidden = true
        
        player.play()
        
        currentScore = 0
    }
    
    private func stop() {
        isPlaying = false
        playGameContainerNode.isHidden = false
    }
    
    private func increaseScore() {
        currentScore += 1
    }
    
    private func increaseIndex() {
        guard let currentIndex = currentIndex, currentIndex + 1 < level.colorTargets.count else {
            self.currentIndex = nil
            return
        }
        self.currentIndex = currentIndex + 1
    }
}


// MARK: Colors {
extension GameScene {
//    private func generateNextColor() {
//        let randomRed = CGFloat.random(in: 0..<1)
//        let randomGreen = CGFloat.random(in: 0..<1)
//        let randomBlue = CGFloat.random(in: 0..<1)
//        let alpha = getAlphaFor(red: randomRed, green: randomGreen, blue: randomBlue)
//
//        colorToMatch = UIColor(displayP3Red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
//        matchColorDeadline = Date.now.timeIntervalSince1970 + 100
//    }
//
    private func isCloseToColor() -> Bool {
        guard let colorToMatch = colorToMatch else {
            return false
        }
        let currentColor = getCurrentSelectedColor()
        return colorToMatch.distance(to: currentColor) < 40
    }
    
    private func getCurrentSelectedColor() -> UIColor {
        let redColorQuantity = getYPercentage(parent: redNode, slider: redSliderNode)
        let greenColorQuantity = getYPercentage(parent: greenNode, slider: greenSliderNode)
        let blueColorQuantity = getYPercentage(parent: blueNode, slider: blueSliderNode)
        let alpha = getAlphaFor(red: redColorQuantity, green: greenColorQuantity, blue: blueColorQuantity)
        
        return UIColor(displayP3Red: redColorQuantity, green: greenColorQuantity, blue: blueColorQuantity, alpha: alpha)
    }
}

// MARK: Utils
extension GameScene {
    private func getYPercentage(parent parentNode: SKNode, slider sliderNode: SKNode) -> CGFloat {
        let height = parentNode.frame.height
        let sliderPosition = sliderNode.position.y
        let absolutePercentage = (sliderPosition + height / 2) / height
        
        return absolutePercentage.cappedBy(0, 1)
    }
    
    private func getAlphaFor(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat{
        return 1
//        return red * green * blue
    }
}

// MARK: AVAudioPlayerDelegate
extension GameScene: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stop()
    }
}
