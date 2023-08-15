//
//  HUD.swift
//  RainCat
//
//  Created by Roman Lantsov on 14.08.2023.
//

import SpriteKit

class HUD: SKNode {
    var quitButtonAction: (() -> ())?
    
    private let scoreKey = "RAINCAT_HIGHSCORE"
    private let scoreLabel = SKLabelNode(fontNamed: "Pixel Digivolve")
    private var score = 0 {
        didSet {
            scoreLabel.text = score.description
        }
    }
    private var highScore = 0
    private var showingHighScore = false
    
    private var quitButton: SKSpriteNode!
    private let quitButtonTexture = SKTexture(imageNamed: "quit_button")
    private let quitButtonPressedTexture = SKTexture(imageNamed: "quit_button_pressed")
    var quitButtonPressed = false
    
    func setup(size: CGSize) {
        let defaults = UserDefaults.standard
        defaults.set(highScore, forKey: scoreKey)
        
        scoreLabel.text = "\(score)"
        scoreLabel.fontSize = 70
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 80)
        scoreLabel.zPosition = 1
        
        addChild(scoreLabel)
        
        quitButton = SKSpriteNode(texture: quitButtonTexture)
        let margin: CGFloat = 15
        quitButton.position = CGPoint(
            x: size.width - quitButton.size.width - margin,
            y: size.height - quitButton.size.height - margin
        )
        quitButton.zPosition = 1000
        
        addChild(quitButton)
    }
    
    func addPoint() {
        score += 1
        
        if score > highScore {
            let defaults = UserDefaults.standard
            highScore = score
            defaults.set(highScore, forKey: scoreKey)
            
            if !showingHighScore {
                showingHighScore = true
                scoreLabel.run(SKAction.scale(to: 1.5, duration: 0.25))
                scoreLabel.fontColor = SKColor(red:0.99, green:0.92, blue:0.55, alpha:1.0)
            }
        }
    }
    
    func resetPoints() {
        score = 0
        
        if showingHighScore {
            showingHighScore = false
            scoreLabel.run(SKAction.scale(to: 1.0, duration: 0.25))
            scoreLabel.fontColor = SKColor.white
        }
    }
    
    func touchBeganAtPoint(point: CGPoint) {
        let containsPoint = quitButton.contains(point)
        
        if quitButtonPressed && !containsPoint {
            //Cancel the last click
            quitButtonPressed = false
            quitButton.texture = quitButtonTexture
        } else if containsPoint {
            quitButton.texture = quitButtonPressedTexture
            quitButtonPressed = true
        }
    }
    
    func touchMovedToPoint(point: CGPoint) {
        if quitButtonPressed {
            if quitButton.contains(point) {
                quitButton.texture = quitButtonPressedTexture
            } else {
                quitButton.texture = quitButtonTexture
            }
        }
    }
    
    func touchEndedAtPoint(point: CGPoint) {
        if quitButton.contains(point) && quitButtonAction != nil {
            quitButtonAction!()
        }
        
        quitButton.texture = quitButtonTexture
    }
    
}
