//
//  Peg.swift
//  Peggle
//
//  Created by Zhang Cheng on 24/1/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

/**
`Peg` represents an peg in the game.

Since we need to encode the peg, it must conform to NSCoding and implement
the required functions.
*/
class Peg: NSObject, NSCoding, PhysicsCircle {
    var uuid: UUID
    var x: CGFloat
    var y: CGFloat
    var color: PegColor
    var radius: CGFloat
    var canMove: Bool
    var velocity: CGVector

    init(x: CGFloat, y: CGFloat, color: PegColor, radius: CGFloat) {
        self.uuid = UUID()
        self.x = x
        self.y = y
        self.color = color
        self.radius = radius
        self.canMove = false
        self.velocity = .zero
    }

    // MARK: Equatable
    static func == (lhs: Peg, rhs: Peg) -> Bool {
        return lhs.x == rhs.x
            && lhs.y == rhs.y
            && lhs.color == rhs.color
            && lhs.radius == rhs.radius
    }

    // MARK: CustomStringConvertible
    override var description: String {
        return "\(self.color)Peg (\(self.x), \(self.y))"
    }

    // MARK: NSCoding
    required convenience init?(coder decoder: NSCoder) {
        guard let x = decoder.decodeObject(forKey: Keys.xKey.rawValue) as? CGFloat else {
            return nil
        }
        guard let y = decoder.decodeObject(forKey: Keys.yKey.rawValue) as? CGFloat else {
            return nil
        }
        guard let colorString = decoder.decodeObject(forKey: Keys.colorKey.rawValue) as? String, let color = PegColor(rawValue: colorString) else {
            return nil
        }
        guard let radius = decoder.decodeObject(forKey: Keys.radiusKey.rawValue) as? CGFloat else {
            return nil
        }

        self.init(x: x, y: y, color: color, radius: radius)
    }

    func encode(with encoder: NSCoder) {
        encoder.encode(self.x, forKey: Keys.xKey.rawValue)
        encoder.encode(self.y, forKey: Keys.yKey.rawValue)
        encoder.encode(self.color.rawValue, forKey: Keys.colorKey.rawValue)
        encoder.encode(self.radius, forKey: Keys.radiusKey.rawValue)
    }
}
