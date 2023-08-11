//
//  Background.swift
//  RainCat
//
//  Created by Roman Lantsov on 11.08.2023.
//

import SpriteKit

public class BackgroundNode: SKNode {

  public func setup(size: CGSize) {
      
    let yPos: CGFloat = size.height * 0.10
    let startPoint = CGPoint(x: 0, y: yPos)
    let endPoint = CGPoint(x: size.width, y: yPos)
      
    physicsBody = SKPhysicsBody(edgeFrom: startPoint, to: endPoint)
    physicsBody?.restitution = 0.3
    physicsBody?.categoryBitMask = BitMaskCategory.floor.rawValue
    physicsBody?.contactTestBitMask = BitMaskCategory.rain.rawValue
      
  }
}
