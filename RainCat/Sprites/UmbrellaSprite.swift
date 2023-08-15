//
//  UmbrellaSprite.swift
//  RainCat
//
//  Created by Roman Lantsov on 11.08.2023.
//

import SpriteKit

class UmbrellaSprite: SKSpriteNode {
    private var destination: CGPoint!
    private let easing: CGFloat = 0.1
    
    static func populateUmbrella() -> UmbrellaSprite {
        let umbrella = UmbrellaSprite(imageNamed: "umbrella")
        umbrella.zPosition = 4
        umbrella.setScale(0.7)
        
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
    
    public func setDestination(destination: CGPoint) {
        self.destination = destination
    }
    
    public func updatePosition(point : CGPoint) {
        position = point
        destination = point
    }
    
    public func update(deltaTime: TimeInterval) {
        // Вычисляем гипотенузу по формуле Пифагора
        let distance = sqrt(pow((destination.x - position.x), 2) + pow((destination.y - position.y), 2))
        
        if distance > 1 {
            let directionX = (destination.x - position.x)
            let directionY = (destination.y - position.y)
            
            position.x += directionX * easing
            position.y += directionY * easing
        } else {
            position = destination;
        }
    }
}
