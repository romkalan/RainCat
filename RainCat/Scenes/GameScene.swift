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
    private var food: FoodSprite!
    private let foodEdgeMargin: CGFloat = 75.0
    
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
        spawnFood()
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        // Initialize _lastUpdateTime if it has not already been
        if self.lastUpdateTime == 0 {
          self.lastUpdateTime = currentTime
        }

        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        umbrella.update(deltaTime: dt)
        cat.update(deltaTime: dt, foodLocation: food.position)

        // Update the Spawn Timer
        currentRainDropSpawnTime += dt

        if currentRainDropSpawnTime > rainDropSpawnRate {
            currentRainDropSpawnTime = 0
            spawnRaindrop()
        }

        self.lastUpdateTime = currentTime
        
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
        raindrop.setScale(0.5)
        raindrop.position = CGPoint(x: xPosition, y: yPosition)
        raindrop.zPosition = 2
        
        raindrop.physicsBody = SKPhysicsBody(texture: raindropTexture, size: raindrop.size)
        raindrop.physicsBody?.density = 0.5 // уменьшим плотность с 1 до 0.5
        raindrop.physicsBody?.categoryBitMask = BitMaskCategory.rain.rawValue
        raindrop.physicsBody?.contactTestBitMask = BitMaskCategory.floor.rawValue | BitMaskCategory.world.rawValue
        
        addChild(raindrop)
    }
    
    private func spawnFood() {
        if let currentFood = food, children.contains(currentFood) {
            food.removeFromParent()
            food.removeAllActions()
            food.physicsBody = nil
        }
        
        food = FoodSprite.populateFood()
        var randomPosition = CGFloat(arc4random()) // получаем случайное значением
        randomPosition = randomPosition.truncatingRemainder(dividingBy: size.width - foodEdgeMargin * 2) // ограничиваем случайное значение размером ширины экрана и вычисляем из этого значения foodEdgeMargin * 2
        randomPosition += foodEdgeMargin // смещаем начало на отступ
        
        food.position = CGPoint(x: randomPosition, y: size.height)
        
        addChild(food)
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
    
    private func handleFoodHit(contact: SKPhysicsContact) {
        var otherBody: SKPhysicsBody
        var foodBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == BitMaskCategory.food.rawValue {
            otherBody = contact.bodyB
            foodBody = contact.bodyA
        } else {
            otherBody = contact.bodyA
            foodBody = contact.bodyB
        }
        
        switch otherBody.categoryBitMask {
        case BitMaskCategory.cat.rawValue:
            print("fed cat")

            fallthrough
        case BitMaskCategory.world.rawValue:
            foodBody.node?.removeFromParent()
            foodBody.node?.physicsBody = nil

            spawnFood()
        default:
            print("something else touches the food")
        }
    }
    
    private func handleCatCollision(contact: SKPhysicsContact) {
        var otherBody: SKPhysicsBody
        
        // ищем другое физическое тело которое сконтактировало с кошкой
        if contact.bodyA.categoryBitMask == BitMaskCategory.cat.rawValue {
            otherBody = contact.bodyB
        } else {
            otherBody = contact.bodyA
        }
        
        // прописываем логику что будет при контакте другого тела с кошкой в зависимости что за другое тело
        switch otherBody.categoryBitMask {
        case BitMaskCategory.rain.rawValue:
            cat.hitByRain()
        case BitMaskCategory.world.rawValue:
            spawnCat()
        default:
            print("something hit the cat")
        }
    }
    
}

extension GameScene {
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == BitMaskCategory.rain.rawValue {
            contact.bodyA.node?.physicsBody?.collisionBitMask = 0
//            contact.bodyA.node?.physicsBody?.categoryBitMask = 0
        } else if contact.bodyB.categoryBitMask == BitMaskCategory.rain.rawValue {
            contact.bodyB.node?.physicsBody?.collisionBitMask = 0
//            contact.bodyB.node?.physicsBody?.categoryBitMask = 0
        }
        
        if contact.bodyA.categoryBitMask == BitMaskCategory.food.rawValue || contact.bodyB.categoryBitMask == BitMaskCategory.food.rawValue {
            handleFoodHit(contact: contact)
            
            return
        }
        
        if contact.bodyA.categoryBitMask == BitMaskCategory.cat.rawValue || contact.bodyB.categoryBitMask == BitMaskCategory.cat.rawValue {
            handleCatCollision(contact: contact)
            
            return
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
