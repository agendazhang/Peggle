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
    static let defaultBoardWidth: CGFloat = 1024
    static let defaultBoardHeight: CGFloat = 1024

    // PeggleGameEngine
    static let gameInterval: Float = 1 / 60

    // PeggleGame
    static let cannonHeight: CGFloat = 60
    static let cannonBallStartingVelocity: CGFloat = 10

    // PhysicsEngine
    static let gravityForce: CGFloat = 0.2

    // PeggleGameCollisionHandler
    static let dampingForceAfterCollision: CGFloat = 0.9

    // PeggleGameCondition
    static let defaultNumberOfCannonBalls: Int = 10
}
