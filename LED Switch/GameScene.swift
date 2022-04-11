//
//  GameScene.swift
//  LED Switch
//
//  Created by Lorin Budaca on 11.04.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var redSliderNode: SKSpriteNode!
    var greenSliderNode: SKSpriteNode!
    var blueSliderNode: SKSpriteNode!
    var redNode: SKSpriteNode!
    var greenNode: SKSpriteNode!
    var blueNode: SKSpriteNode!
    var backgroundNode: SKSpriteNode!
    var playGameContainerNode: SKSpriteNode!
    var remainingTimeLabel: SKLabelNode!
    var currentScoreLabel: SKLabelNode!
    var colorToMatchNode: SKSpriteNode!
    
    var isPlaying = false
    var matchColorDeadline: TimeInterval?
    var colorToMatch: UIColor?
    var currentScore = 0
    
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
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateUI()
        
        if isPlaying {
            guard let matchColorDeadline = matchColorDeadline, Date.now.timeIntervalSince1970 < matchColorDeadline else {
                isPlaying = false
                matchColorDeadline = nil
                return
            }
            playGameContainerNode.isHidden = true
            if isCloseToColor() {
                generateNextColor()
                increaseScore()
            }
        } else {
            playGameContainerNode.isHidden = false
        }
    }
}

extension CGFloat {
    func cappedBy(_ a: CGFloat, _ b: CGFloat) -> CGFloat{
        var a = a, b = b
        if !(a > b) { swap(&a, &b) }
        
        if self > a { return a }
        if self < b { return b }
        return self
    }
}

extension Array where Element == CGFloat {
    func sum() -> CGFloat {
        return reduce(0, +)
    }
}

extension UIColor {
    func getComponents() -> [CGFloat] {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return [red, green, blue, alpha]
    }
    
    func distance(to color: UIColor) -> CGFloat {
        return 255 * zip(self.getComponents(), color.getComponents())
            .map(-)
            .map(abs)
            .sum()
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
        let now = Date.now.timeIntervalSince1970
        let remainingTime = (matchColorDeadline ?? now) - now
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
                startGame()
            }
        }
    }
}

// MARK: Game logic
extension GameScene {
    private func startGame() {
        isPlaying = true
        currentScore = 0
        generateNextColor()
    }
    
    private func increaseScore() {
        currentScore += 1
    }
}


// MARK: Colors {
extension GameScene {
    private func generateNextColor() {
        let randomRed = CGFloat.random(in: 0..<1)
        let randomGreen = CGFloat.random(in: 0..<1)
        let randomBlue = CGFloat.random(in: 0..<1)
        let alpha = getAlphaFor(red: randomRed, green: randomGreen, blue: randomBlue)
        
        colorToMatch = UIColor(displayP3Red: randomRed, green: randomGreen, blue: randomBlue, alpha: alpha)
        matchColorDeadline = Date.now.timeIntervalSince1970 + 100
    }
    
    private func isCloseToColor() -> Bool {
        guard let colorToMatch = colorToMatch else {
            return false
        }
        let currentColor = getCurrentSelectedColor()
        return colorToMatch.distance(to: currentColor) < 10
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
