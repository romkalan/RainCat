//
//  CatSprite.swift
//  RainCat
//
//  Created by Roman Lantsov on 12.08.2023.
//

import SpriteKit

class CatSprite: SKSpriteNode {
    private let walkingActionKey = "walking"
    private let movementSpeed: CGFloat = 100
    
    private var timeSinceLastHit : TimeInterval = 2
    private let maxFlailTime : TimeInterval = 2
    
    private var currentRainHits = 4 // счетчик количества ударов по кошке
    private let maxRainHits = 4 // количество ударов до мяуканья
    
    private let walkTextureAtlas = [
        SKTexture(imageNamed: "cat_one"),
        SKTexture(imageNamed: "cat_two")
    ]
    
    private let meowSFX = [
        "cat_meow_1.mp3",
        "cat_meow_2.mp3",
        "cat_meow_3.mp3",
        "cat_meow_4.mp3",
        "cat_meow_5.mp3",
        "cat_meow_6.mp3"
    ]
    
    static func populateCat() -> CatSprite {
        let catSprite = CatSprite(imageNamed: "cat_one")
        
        catSprite.zPosition = 5
        
        catSprite.physicsBody = SKPhysicsBody(circleOfRadius: catSprite.size.width / 2)
        catSprite.physicsBody?.categoryBitMask = BitMaskCategory.cat.rawValue
        catSprite.physicsBody?.contactTestBitMask = BitMaskCategory.rain.rawValue | BitMaskCategory.world.rawValue | BitMaskCategory.food.rawValue
        
        return catSprite
    }
    
    public func update(deltaTime: TimeInterval, foodLocation: CGPoint) {
        timeSinceLastHit += deltaTime
        
        if timeSinceLastHit > maxFlailTime {
            if action(forKey: walkingActionKey) == nil {
                let walkingAction = SKAction.repeatForever(SKAction.animate(
                    with: walkTextureAtlas,
                    timePerFrame: 0.1,
                    resize: false,
                    restore: true)
                )
                run(walkingAction, withKey: walkingActionKey)
            }
            
            if self.zRotation != 0 && action(forKey: "action_rotate") == nil {
                run(SKAction.rotate(toAngle: 0, duration: 0.25), withKey: "action_rotate")
            }
            
            if foodLocation.y > position.y && abs(foodLocation.x - position.x) < 2 {
                physicsBody?.velocity.dx = 0
                removeAction(forKey: walkingActionKey)
                texture = walkTextureAtlas[1]
            } else if foodLocation.x < position.x {
                //Food is left
                physicsBody?.velocity.dx = -movementSpeed
                xScale = -1 // редактируем ширину спрайта (отзеракаливаем его)
            } else {
                //Food is right
                physicsBody?.velocity.dx = movementSpeed
                xScale = 1 // редактируем ширину спрайта (отзеркаливаем если у нас было -1)
            }
            
            physicsBody?.angularVelocity = 0
        }
    }
    
    public func hitByRain() {
        timeSinceLastHit = 0
        removeAction(forKey: walkingActionKey)
        
        if SoundManager.shared.isMuted {
            return
        }
        
        if currentRainHits < maxRainHits {
            currentRainHits += 1
            
            return
        }
        
        if action(forKey: "action_sound_effect") == nil {
            currentRainHits = 0
            
            let selectedSFX = Int(arc4random_uniform(UInt32(meowSFX.count))) // выбираем случайное число от 0 до максимального числа из массива
            run(SKAction.playSoundFileNamed(meowSFX[selectedSFX], waitForCompletion: true), withKey: "action_sound_effect")
        }
    }
}
