//
//  PhysicsTriangle.swift
//  Peggle
//
//  Created by Zhang Cheng on 23/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

/**
`PhysicsTriangle` represents an equilateral triangle.
*/
protocol PhysicsTriangle: PhysicsObject {
    // Since the equilateral triangle has 3 verticces, this property represents the distance
    // from its center to any of the 3 vertices.
    var centerToVerticeDist: CGFloat { get set }
    // This property represents the angle of its rotation
    var angle: CGFloat { get set }

    func getVerticesCoordinates() -> [CGPoint]
}
