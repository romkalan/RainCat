//
//  GameScene.swift
//  RainCat
//
//  Created by Roman Lantsov on 11.08.2023.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var lastUpdateTime: TimeInterval = 0
    private var currentRainDropSpawnTime: TimeInterval = 0
    private var rainDropSpawnRate: TimeInterval = 0.5
    
    private let background = BackgroundNode()
    private var umbrella: UmbrellaSprite!
    private var cat: CatSprite!
    
    let raindropTexture = SKTexture(imageNamed: "rain_drop")
    
    override func sceneDidLoad() {
        
        self.physicsWorld.contactDelegate = self
        
        var worldFrame = frame
        worldFrame.origin.x -= 100
        worldFrame.origin.y -= 100
        worldFrame.size.height += 200
        worldFrame.size.width += 200
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
        self.physicsBody?.categoryBitMask = BitMaskCategory.world.rawValue
        
        self.lastUpdateTime = 0
        
        background.setup(size: size)
        addChild(background)
        
        umbrella = UmbrellaSprite.populateUmbrella()
        umbrella.updatePosition(point: CGPoint(x: frame.midX, y: frame.midY))
        addChild(umbrella)
        
        spawnCat()
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
          self.lastUpdateTime = currentTime
        }

        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime

        // Update the Spawn Timer
        currentRainDropSpawnTime += dt

        if currentRainDropSpawnTime > rainDropSpawnRate {
            currentRainDropSpawnTime = 0
            spawnRaindrop()
        }

        self.lastUpdateTime = currentTime
        
        umbrella.update(deltaTime: dt)
    }
    
    // Touches movement
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        if let point = touchPoint {
            umbrella.setDestination(destination: point)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first?.location(in: self)
        
        if let point = touchPoint {
            umbrella.setDestination(destination: point)
        }
    }
    // Spawn objects
    private func spawnRaindrop() {
        let raindrop = SKSpriteNode(texture: raindropTexture)
        
        let xPosition = CGFloat(arc4random()).truncatingRemainder(dividingBy: size.width)
        let yPosition = size.height + raindrop.size.height
        raindrop.position = CGPoint(x: xPosition, y: yPosition)
        raindrop.zPosition = 2
        
        raindrop.physicsBody = SKPhysicsBody(texture: raindropTexture, size: raindrop.size)
        raindrop.physicsBody?.categoryBitMask = BitMaskCategory.rain.rawValue
        raindrop.physicsBody?.contactTestBitMask = BitMaskCategory.floor.rawValue | BitMaskCategory.world.rawValue
        
        addChild(raindrop)
    }
    
    private func spawnCat() {
        if let currentCat = cat, children.contains(currentCat) {
            cat.removeFromParent()
            cat.removeAllActions()
            cat.physicsBody = nil
        }
        
        cat = CatSprite.populateCat()
        cat.position = CGPoint(x: umbrella.position.x, y: umbrella.position.y - 30)
        
        addChild(cat)
    }
    
}

extension GameScene {
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == BitMaskCategory.rain.rawValue {
            contact.bodyA.node?.physicsBody?.collisionBitMask = 0
            contact.bodyA.node?.physicsBody?.categoryBitMask = 0
        } else if contact.bodyB.categoryBitMask == BitMaskCategory.rain.rawValue {
            contact.bodyB.node?.physicsBody?.collisionBitMask = 0
            contact.bodyB.node?.physicsBody?.categoryBitMask = 0
        }
        
        if contact.bodyA.categoryBitMask == BitMaskCategory.world.rawValue {
            contact.bodyB.node?.removeFromParent()
            contact.bodyB.node?.physicsBody = nil
            contact.bodyB.node?.removeAllActions()
        } else if contact.bodyB.categoryBitMask == BitMaskCategory.world.rawValue {
            contact.bodyA.node?.removeFromParent()
            contact.bodyA.node?.physicsBody = nil
            contact.bodyA.node?.removeAllActions()
        }
    }
}
