//
//  BitMaskCategory.swift
//  RainCat
//
//  Created by Roman Lantsov on 11.08.2023.
//

import SpriteKit

extension SKPhysicsBody {
    var category: BitMaskCategory {
        get {
            return BitMaskCategory(rawValue: self.categoryBitMask)
        }
        set {
            self.categoryBitMask = newValue.rawValue
        }
    }
}

struct BitMaskCategory: OptionSet {
    
    let rawValue: UInt32
    
    static let none = BitMaskCategory(rawValue: 0 << 0)
    static let world = BitMaskCategory(rawValue: 1 << 0)
    static let rain = BitMaskCategory(rawValue: 1 << 1)
    static let floor = BitMaskCategory(rawValue: 1 << 2)
    static let all = BitMaskCategory(rawValue: UInt32.max)

}
