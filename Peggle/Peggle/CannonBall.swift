//
//  CannonBall.swift
//  Peggle
//
//  Created by Zhang Cheng on 8/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

class CannonBall: NSObject, PhysicsCircle {
    var uuid: UUID
    var x: CGFloat
    var y: CGFloat
    var radius: CGFloat
    var canMove: Bool
    var velocity: CGVector

    init(x: CGFloat, y: CGFloat, radius: CGFloat, velocity: CGVector) {
        self.uuid = UUID()
        self.x = x
        self.y = y
        self.radius = radius
        self.canMove = true
        self.velocity = velocity
    }

    // MARK: CustomStringConvertible
    override var description: String {
        return "Cannon Ball at (\(self.x), \(self.y)), moving (\(self.velocity.dx), \(self.velocity.dy))"
    }
}
