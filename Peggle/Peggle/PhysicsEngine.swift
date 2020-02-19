//
//  PhysicsEngine.swift
//  Peggle
//
//  Created by Zhang Cheng on 7/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

class PhysicsEngine {
    var physicsObjects: [PhysicsObject]
    var physicsCollisionHandler: PhysicsCollisionHandler

    init(physicsObjects: [PhysicsObject], physicsCollisionHandler: PhysicsCollisionHandler) {
        self.physicsObjects = physicsObjects
        self.physicsCollisionHandler = physicsCollisionHandler
    }

    func moveObjects() {
        for physicsObject in self.physicsObjects {
            if moveObject(physicsObject: physicsObject) {
                checkCollision(physicsObject: physicsObject)
            }
        }
    }

    func moveObject(physicsObject: PhysicsObject) -> Bool {
        if physicsObject.velocity == .zero {
            return false
        }

        physicsObject.x += physicsObject.velocity.dx
        physicsObject.y += physicsObject.velocity.dy

        return true
    }

    func addGravityToObjects() {
        for physicsObject in self.physicsObjects where physicsObject.velocity != .zero {
            physicsObject.velocity.dy += NumberConstants.gravityForce
        }
    }

    private func checkCollision(physicsObject: PhysicsObject) {
        if let physicsCircle = physicsObject as? PhysicsCircle {
            checkCollisionForCircle(physicsCircle: physicsCircle)
            return
        }

        if let physicsRectangle = physicsObject as? PhysicsRectangle {
            checkCollisionForRectangle(physicsRectangle: physicsRectangle)
            return
        }
    }

    private func checkCollisionForCircle(physicsCircle: PhysicsCircle) {
        for physicsObject in physicsObjects {
            if let physicsCircle2 = physicsObject as? PhysicsCircle {
                checkCollisionForCircleWithCircle(physicsCircle: physicsCircle,
                    physicsCircle2: physicsCircle2)
                continue
            }

            if let physicsRectangle = physicsObject as? PhysicsRectangle {
                checkCollisionForCircleWithRectangle(physicsCircle: physicsCircle,
                    physicsRectangle: physicsRectangle)
                continue
            }
        }
    }

    private func checkCollisionForRectangle(physicsRectangle: PhysicsRectangle) {
        for physicsObject in physicsObjects {
            if let physicsCircle = physicsObject as? PhysicsCircle {
                checkCollisionForCircleWithRectangle(physicsCircle: physicsCircle,
                    physicsRectangle: physicsRectangle)
                continue
            }

            if let physicsRectangle2 = physicsObject as? PhysicsRectangle {
                checkCollisionForRectangleWithRectangle(physicsRectangle:
                    physicsRectangle, physicsRectangle2: physicsRectangle2)
                continue
            }
        }
    }

    private func checkCollisionForCircleWithCircle(physicsCircle: PhysicsCircle,
        physicsCircle2: PhysicsCircle) {

        // Cannot be the same object
        guard physicsCircle !== physicsCircle2 else {
            return
        }

        let xDistance = physicsCircle.x - physicsCircle2.x
        let yDistance = physicsCircle.y - physicsCircle2.y
        let distanceBetweenCenter = sqrt(xDistance * xDistance + yDistance * yDistance)

        // If the distance between the centre of physicsCircle and physicsCircle2 is less
        // than the sum of their radius, a collision is detected
        guard physicsCircle.radius + physicsCircle2.radius > distanceBetweenCenter else {
            return
        }

        physicsCollisionHandler.handleCollisionForCircleWithCircle(physicsCircle:
            physicsCircle, physicsCircle2: physicsCircle2)
    }

    private func checkCollisionForCircleWithRectangle(physicsCircle: PhysicsCircle,
        physicsRectangle: PhysicsRectangle) {

        // Find the x-coordinate of the nearest left/right side of the rectangle to the
        // circle
        let rectangleNearestX = max(physicsRectangle.x - physicsRectangle.width / 2,
            min(physicsCircle.x, physicsRectangle.x + physicsRectangle.width / 2))

        // Find the y-coordinate of the nearest top/bottom side of the rectangle to the
        // circle
        let rectangleNearestY = max(physicsRectangle.y - physicsRectangle.height / 2,
            min(physicsCircle.y, physicsRectangle.y + physicsRectangle.height / 2))

        let xDistance = physicsCircle.x - rectangleNearestX
        let yDistance = physicsCircle.y - rectangleNearestY

        let distanceToNearestRectanglePoint = sqrt(xDistance * xDistance + yDistance *
            yDistance)

        guard physicsCircle.radius > distanceToNearestRectanglePoint else {
            return
        }

        physicsCollisionHandler.handleCollisionForCircleWithRectangle(physicsCircle:
            physicsCircle, physicsRectangle: physicsRectangle)
    }

    private func checkCollisionForRectangleWithRectangle(physicsRectangle: PhysicsRectangle,
        physicsRectangle2: PhysicsRectangle) {

        // Cannot be the same object
        guard physicsRectangle !== physicsRectangle2 else {
            return
        }

        let rectangle1HalfWidth = physicsRectangle.width / 2
        let rectangle1HalfHeight = physicsRectangle.height / 2
        let rectangle2HalfWidth = physicsRectangle2.width / 2
        let rectangle2HalfHeight = physicsRectangle2.height / 2

        // Find the coordinates of the top right and bottom left corners of the rectangles
        let rectangle1TopRightX = physicsRectangle.x + rectangle1HalfWidth
        let rectangle1TopRightY = physicsRectangle.y - rectangle1HalfHeight
        let rectangle2TopRightX = physicsRectangle2.x + rectangle2HalfWidth
        let rectangle2TopRightY = physicsRectangle2.y - rectangle2HalfHeight

        let rectangle1BottomLeftX = physicsRectangle.x - rectangle1HalfWidth
        let rectangle1BottomLeftY = physicsRectangle.y + rectangle1HalfHeight
        let rectangle2BottomLeftX = physicsRectangle2.x - rectangle2HalfWidth
        let rectangle2BottomLeftY = physicsRectangle2.y + rectangle2HalfHeight

        if rectangle1TopRightX <= rectangle2BottomLeftX
            || rectangle1BottomLeftX >= rectangle2TopRightX {
            return
        }

        if rectangle1TopRightY <= rectangle2BottomLeftY
            || rectangle1BottomLeftY >= rectangle2TopRightY {
            return
        }

        physicsCollisionHandler.handleCollisionForRectangleWithRectangle(physicsRectangle:
            physicsRectangle, physicsRectangle2: physicsRectangle2)
    }

}
