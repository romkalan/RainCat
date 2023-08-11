//
//  UmbrellaSprite.swift
//  RainCat
//
//  Created by Roman Lantsov on 11.08.2023.
//

import SpriteKit

class UmbrellaSprite: SKSpriteNode {
    static func populateUmbrella(at point: CGPoint) -> UmbrellaSprite {
        let umbrella = UmbrellaSprite(imageNamed: "umbrella")
        umbrella.position = point
        umbrella.zPosition = 4
        
        let path = UIBezierPath()
        path.move(to: CGPoint())
        path.addLine(to: CGPoint(x: -umbrella.size.width / 2 - 30, y: 0))
        path.addLine(to: CGPoint(x: 0, y: umbrella.size.height / 2))
        path.addLine(to: CGPoint(x: umbrella.size.width / 2 + 30, y: 0))

        umbrella.physicsBody = SKPhysicsBody(polygonFrom: path.cgPath)
        umbrella.physicsBody?.isDynamic = false
        umbrella.physicsBody?.restitution = 0.9
        
        return umbrella
    }
}
