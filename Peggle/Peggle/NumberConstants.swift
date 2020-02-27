//
//  NumberConstants.swift
//  Peggle
//
//  Created by Zhang Cheng on 26/1/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

class NumberConstants {

    // PegBoard
    static let numPegRows = 20
    static let numPegCols = 20
    static let defaultBoardWidth: CGFloat = 834
    static let defaultBoardHeight: CGFloat = 834
    static let increaseSizeRatio: CGFloat = 1.1
    static let decreaseSizeRatio: CGFloat = 0.9
    static let maximumSizeRatio: CGFloat = 2.0
    static let minimumSizeRatio: CGFloat = 0.5

    // PeggleGameEngine
    static let gameInterval: Float = 1 / 60
    static let cannonHeight: CGFloat = 60
    static let cannonBallStartingVelocity: CGFloat = 10
    static let bucketHeight: CGFloat = 30
    static let bucketWidth: CGFloat = 100
    static let bucketStartingVelocity: CGVector = CGVector(dx: 2, dy: 0)
    static let minimumOrangePegsRemainingToActivateSpaceBlast: Int = 10
    static let maximumDistanceToActivateSpaceBlast: CGFloat = 80

    // PhysicsEngine
    static let gravityForce: CGFloat = 0.2

    // PeggleGameCollisionHandler
    static let dampingForceAfterCollision: CGFloat = 0.9

    // PeggleGameCondition
    static let defaultNumberOfCannonBalls: Int = 10
}
