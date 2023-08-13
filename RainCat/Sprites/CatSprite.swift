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
    
    private let walkTextureAtlas = [
        SKTexture(imageNamed: "cat_one"),
        SKTexture(imageNamed: "cat_two")
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
        if action(forKey: "walking") == nil {
            let walkingAction = SKAction.repeatForever(SKAction.animate(
                with: walkTextureAtlas,
                timePerFrame: 0.1,
                resize: false,
                restore: true)
            )
            run(walkingAction, withKey: "walking")
        }
        
        if foodLocation.x < position.x {
            //Food is left
            position.x -= movementSpeed * CGFloat(deltaTime)
            xScale = -1 // редактируем ширину спрайта (отзеракаливаем его)
        } else {
            //Food is right
            position.x += movementSpeed * CGFloat(deltaTime)
            xScale = 1 // редактируем ширину спрайта (отзеркаливаем если у нас было -1)
        }
    }
}
