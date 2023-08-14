//
//  HUD.swift
//  RainCat
//
//  Created by Roman Lantsov on 14.08.2023.
//

import SpriteKit

class HUD: SKNode {
    private let scoreKey = "RAINCAT_HIGHSCORE"
    private let scoreLabel = SKLabelNode(fontNamed: "Pixel Digivolve")
    private var score = 0 {
        didSet {
            scoreLabel.text = score.description
        }
    }
    private var highScore = 0
    private var showingHighScore = false
    
    func setup(size: CGSize) {
        let defaults = UserDefaults.standard
        defaults.set(highScore, forKey: scoreKey)
        
        scoreLabel.text = "\(score)"
        scoreLabel.fontSize = 70
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        scoreLabel.zPosition = 1
        
        addChild(scoreLabel)
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
    
}
