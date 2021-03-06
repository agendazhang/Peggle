//
//  PeggleGameCollisionHandler.swift
//  Peggle
//
//  Created by Zhang Cheng on 8/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

class PeggleGameCollisionHandler: PhysicsCollisionHandler {
    unowned var gameEngine: PeggleGameEngine

    init(gameEngine: PeggleGameEngine) {
        self.gameEngine = gameEngine
    }

    // In our Peggle game, the only time where this happens is when a moving `CannonBall`
    // collides with a stationary `Peg`
    func handleCollisionForCircleWithCircle(physicsCircle: PhysicsCircle, physicsCircle2: PhysicsCircle) {

        guard let cannonBall = physicsCircle as? CannonBall else {
            return
        }

        guard let peg = physicsCircle2 as? Peg else {
            return
        }

        guard physicsCircle.canMove && !physicsCircle2.canMove else {
            return
        }

        gameEngine.cannonBallHitsPeg(peg: peg)

        // At the start, the 2 circles will be overlapped
        var xDistance = cannonBall.x - peg.x
        var yDistance = cannonBall.y - peg.y
        let distanceBetweenCircles = sqrt(xDistance * xDistance + yDistance * yDistance)

        // Calculate the overlap distance between the 2 circles
        let overlapDistance = cannonBall.radius + peg.radius - distanceBetweenCircles

        // Remove the overlap so that the edges of the 2 circles are touching each other
        cannonBall.x += overlapDistance * (xDistance) / distanceBetweenCircles
        cannonBall.y += overlapDistance * (yDistance) / distanceBetweenCircles

        // Recalculate the distances between the center of the 2 circles
        xDistance = peg.x - cannonBall.x
        yDistance = peg.y - cannonBall.y

        let angle = atan2(yDistance, xDistance)

        // This algorithm for handling collision between 2 circles is referenced from:
        // https://www.youtube.com/watch?v=guWIF87CmBg
        // In our algorithm, we will rotate the centre of the first circle such that the
        // axis of collision is horizontal. In this way, the first circle will move in the
        // opposite x-direction after colliding.
        let cannonBallRotatedVelocityDx = cos(angle) * cannonBall.velocity.dx +
            sin(angle) * cannonBall.velocity.dy
        let cannonBallRotatedVelocityDy = -sin(angle) * cannonBall.velocity.dx +
            cos(angle) * cannonBall.velocity.dy

        // Add a damping force to reduce the velocity in the opposite x-direction after
        // collision
        let cannonBallRotatedVelocityFinalDx =
            NumberConstants.dampingForceAfterCollision * -cannonBallRotatedVelocityDx

        // Rotate back the axis of collision
        cannonBall.velocity.dx = cos(angle) * cannonBallRotatedVelocityFinalDx -
            sin(angle) * cannonBallRotatedVelocityDy
        cannonBall.velocity.dy = sin(angle) * cannonBallRotatedVelocityFinalDx +
            cos(angle) * cannonBallRotatedVelocityDy
    }

    // In our Peggle game, the only time where this happens is when a moving `CannonBall`
    // collides with a stationary `Wall`
    func handleCollisionForCircleWithRectangle(physicsCircle: PhysicsCircle, physicsRectangle: PhysicsRectangle) {

        if let cannonBall = physicsCircle as? CannonBall, let wall = physicsRectangle as?
            Wall {
            handleCollisionForCannonBallWithWall(cannonBall: cannonBall, wall: wall)
            return
        }

        if let cannonBall = physicsCircle as? CannonBall, let bucket = physicsRectangle as?
            Bucket {
            handleCollisionForCannonBallWithBucket(cannonBall: cannonBall, bucket: bucket)
            return
        }
    }

    private func handleCollisionForCannonBallWithWall(cannonBall: CannonBall, wall: Wall) {
        guard cannonBall.canMove && !wall.canMove else {
            return
        }

        // in our algorithm, after colliding with a wall, the ball will make a mirror image
        // deflection with respect to the normal of the wall, where the angle of incidence
        // equals the angle of reflection
        switch wall.wallType {
        case .topWall:
            cannonBall.velocity.dy = cannonBall.velocity.dy * -1
        case .leftWall, .rightWall:
            cannonBall.velocity.dx = cannonBall.velocity.dx * -1
        case .bottomWall:
            gameEngine.cannonBallHitsBottomWall(cannonBall: cannonBall)
        }
    }

    private func handleCollisionForCannonBallWithBucket(cannonBall: CannonBall, bucket: Bucket) {
        guard cannonBall.canMove && bucket.canMove else {
            return
        }

        let bucketLeftX = bucket.x - bucket.width / 2
        let bucketRightX = bucket.x + bucket.width / 2
        let bucketTopY = bucket.y - bucket.height / 2

        if cannonBall.x > bucketLeftX && cannonBall.x < bucketRightX && cannonBall.y <
            bucketTopY {
            // Since the bucket is modelled as a rectangle, the cannon ball can only fall
            // into the bucket if it overlaps with the top line of the rectangle
            gameEngine.cannonBallEntersBucket(cannonBall: cannonBall)
        } else {
            // Else if the cannon ball overlaps with the sides of the rectangle, it will
            // bounce away in the opposite x-direction
            cannonBall.velocity.dx = cannonBall.velocity.dx * -1
        }
    }

    // In our Peggle game, the only time where this happens is when a moving `Bucket`
    // collides with a stationary `Wall`
    func handleCollisionForRectangleWithRectangle(physicsRectangle: PhysicsRectangle, physicsRectangle2: PhysicsRectangle) {

        guard let bucket = physicsRectangle as? Bucket else {
            return
        }

        guard let _ = physicsRectangle2 as? Wall else {
            return
        }

        guard physicsRectangle.canMove && !physicsRectangle2.canMove else {
            return
        }

        bucket.velocity.dx = bucket.velocity.dx * -1
    }

}
