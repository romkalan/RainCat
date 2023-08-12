//
//  CatSprite.swift
//  RainCat
//
//  Created by Roman Lantsov on 12.08.2023.
//

import SpriteKit

class CatSprite: SKSpriteNode {
    static func populateCat() -> CatSprite {
        let catSprite = CatSprite(imageNamed: "cat_one")
        
        catSprite.zPosition = 5
        catSprite.physicsBody = SKPhysicsBody(circleOfRadius: catSprite.size.width / 2)
        catSprite.physicsBody?.categoryBitMask = BitMaskCategory.cat.rawValue
        catSprite.physicsBody?.contactTestBitMask = BitMaskCategory.rain.rawValue | BitMaskCategory.world.rawValue
        
        return catSprite
    }
    
    public func update(deltaTime: TimeInterval) {
        
    }
}
