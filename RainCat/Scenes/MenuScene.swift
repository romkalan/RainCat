//
//  MenuScene.swift
//  RainCat
//
//  Created by Roman Lantsov on 15.08.2023.
//

import SpriteKit

class MenuScene: SKScene {
    let startButtonTexture = SKTexture(imageNamed: "button_start")
    let startButtonPressedTexture = SKTexture(imageNamed: "button_start_pressed")
    let soundButtonTexture = SKTexture(imageNamed: "speaker_on")
    let soundButtonOffTexture = SKTexture(imageNamed: "speaker_off")
    
    let highScoreLabel = SKLabelNode(fontNamed: "Pixel Digivolve")
    let logo = SKSpriteNode(imageNamed: "logo")
    var startButton: SKSpriteNode!
    var soundButton: SKSpriteNode!
    var selectedButton: SKSpriteNode?
    
    private let scoreKey = "RAINCAT_HIGHSCORE"
    
    override func sceneDidLoad() {
        backgroundColor = SKColor(red:0.30, green:0.81, blue:0.89, alpha:1.0)
        
        //Set up logo
        logo.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        addChild(logo)
        
        //Set up start button
        startButton = SKSpriteNode(texture: startButtonTexture)
        startButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - startButton.size.height / 2)
        addChild(startButton)
        
        //Set up sound button
        let edgeMargin : CGFloat = 25
        soundButton = SKSpriteNode(texture: soundButtonTexture)
        soundButton.position = CGPoint(
            x: size.width - soundButton.size.width / 2 - edgeMargin,
            y: soundButton.size.height / 2 + edgeMargin
        )
        addChild(soundButton)
        
        //Set up high-score node
        let defaults = UserDefaults.standard
        let highScore = defaults.integer(forKey: scoreKey)

        highScoreLabel.text = "\(highScore)"
        highScoreLabel.fontSize = 90
        highScoreLabel.verticalAlignmentMode = .top
        highScoreLabel.position = CGPoint(
            x: size.width / 2,
            y: startButton.position.y - startButton.size.height / 2 - edgeMargin
        )
        highScoreLabel.zPosition = 1
        addChild(highScoreLabel)
    }
    
}
