//
//  Wall.swift
//  Peggle
//
//  Created by Zhang Cheng on 8/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

/**
`Wall` represents the 4 sides of the game board.
*/
class Wall: NSObject, PhysicsRectangle {
    var uuid: UUID
    var x: CGFloat
    var y: CGFloat
    var wallType: WallType
    var width: CGFloat
    var height: CGFloat
    var canMove: Bool
    var velocity: CGVector

    init(x: CGFloat, y: CGFloat, wallType: WallType, width: CGFloat, height: CGFloat) {
        self.uuid = UUID()
        self.x = x
        self.y = y
        self.wallType = wallType
        self.width = width
        self.height = height
        self.canMove = false
        self.velocity = .zero
    }

    // MARK: Equatable
    static func == (lhs: Wall, rhs: Wall) -> Bool {
        return lhs.x == rhs.x
            && lhs.y == rhs.y
            && lhs.wallType == rhs.wallType
            && lhs.width == rhs.width
            && lhs.height == rhs.height
    }

    // MARK: CustomStringConvertible
    override var description: String {
        return "\(self.wallType) (\(self.x), \(self.y))"
    }
}
