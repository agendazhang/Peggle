//
//  Bucket.swift
//  Peggle
//
//  Created by Zhang Cheng on 21/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

class Bucket: NSObject, PhysicsRectangle {
    var uuid: UUID
    var x: CGFloat
    var y: CGFloat
    var width: CGFloat
    var height: CGFloat
    var canMove: Bool
    var velocity: CGVector

    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, velocity: CGVector) {
        self.uuid = UUID()
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.canMove = true
        self.velocity = velocity
    }

    // MARK: Equatable
    static func == (lhs: Bucket, rhs: Bucket) -> Bool {
        return lhs.x == rhs.x
            && lhs.y == rhs.y
            && lhs.width == rhs.width
            && lhs.height == rhs.height
    }

    // MARK: CustomStringConvertible
    override var description: String {
        return "Bucket (\(self.x), \(self.y))"
    }
}
