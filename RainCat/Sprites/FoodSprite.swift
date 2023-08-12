//
//  FoodSprite.swift
//  RainCat
//
//  Created by Roman Lantsov on 12.08.2023.
//

import SpriteKit

class FoodSprite: SKSpriteNode {
    static func populateFood() -> FoodSprite {
        let food = FoodSprite(imageNamed: "food_dish")
        food.zPosition = 5
        
        food.physicsBody = SKPhysicsBody(rectangleOf: food.size)
        food.physicsBody?.categoryBitMask = BitMaskCategory.food.rawValue
        food.physicsBody?.contactTestBitMask = BitMaskCategory.rain.rawValue | BitMaskCategory.cat.rawValue | BitMaskCategory.world.rawValue
        
        return food
    }
}
