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
        soundButton = SKSpriteNode(
            texture: SoundManager.shared.isMuted
                ? soundButtonOffTexture
                : soundButtonTexture
        )
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if selectedButton != nil {
                handleStartButtonHover(isHovering: false)
                handleSoundButtonHover(isHovering: false)
            }
            
            if startButton.contains(touch.location(in: self)) {
                selectedButton = startButton
                handleStartButtonHover(isHovering: true)
            } else if soundButton.contains(touch.location(in: self)) {
                selectedButton = soundButton
                handleSoundButtonHover(isHovering: true)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // Check which button was clicked (if any)
        if selectedButton == startButton {
            handleStartButtonHover(isHovering: (startButton.contains(touch.location(in: self))))
        } else if selectedButton == soundButton {
            handleSoundButtonHover(isHovering: (soundButton.contains(touch.location(in: self))))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if selectedButton == startButton {
            // Start button clicked
            handleStartButtonHover(isHovering: false)
            
            if (startButton.contains(touch.location(in: self))) {
                handleStartButtonClick()
            }
            
        } else if selectedButton == soundButton {
            // Sound button clicked
            handleSoundButtonHover(isHovering: false)
            
            if (soundButton.contains(touch.location(in: self))) {
                handleSoundButtonClick()
            }
        }
        
        selectedButton = nil
    }
    
    
    
    /// Handles start button hover behavior
    func handleStartButtonHover(isHovering : Bool) {
        startButton.texture = isHovering ? startButtonPressedTexture : startButtonTexture
    }

    /// Handles sound button hover behavior
    func handleSoundButtonHover(isHovering : Bool) {
        soundButton.alpha = isHovering ? 0.5 : 1.0
    }
    
    /// Stubbed out start button on click method
    func handleStartButtonClick() {
        let transition = SKTransition.reveal(with: .down, duration: 0.75)
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        view?.presentScene(gameScene, transition: transition)
    }

    /// Stubbed out sound button on click method
    func handleSoundButtonClick() {
        if SoundManager.shared.toggleMute() {
            soundButton.texture = soundButtonOffTexture
        } else {
            soundButton.texture = soundButtonTexture
        }
    }
    
}
