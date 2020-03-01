//
//  PhysicsCollisionHandler.swift
//  Peggle
//
//  Created by Zhang Cheng on 8/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

protocol PhysicsCollisionHandler {

    func handleCollisionForCircleWithCircle(physicsCircle: PhysicsCircle, physicsCircle2: PhysicsCircle)

    func handleCollisionForCircleWithRectangle(physicsCircle: PhysicsCircle,
        physicsRectangle: PhysicsRectangle)

    func handleCollisionForRectangleWithRectangle(physicsRectangle: PhysicsRectangle,
        physicsRectangle2: PhysicsRectangle)
}
