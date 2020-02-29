//
//  NotificationNameExtensions.swift
//  Peggle
//
//  Created by Zhang Cheng on 21/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import Foundation

extension Notification.Name {
    // PeggleGameViewController
    static let winGameNotification = Notification.Name("winGameNotification")
    static let loseGameNotification = Notification.Name("loseGameNotification")
    static let numOrangePegsRemainingNotification =
        Notification.Name("numOrangePegsRemainingNotification")
    static let numCannonBallsRemainingNotification =
        Notification.Name("numCannonBallsRemainingNotification")
    static let freeBallNotification = Notification.Name("freeBallNotification")
    static let spaceBlastNotification = Notification.Name("spaceBlastNotification")
    static let spookyBallNotification = Notification.Name("spookyBallNotification")
    static let gameTimeLeftNotification = Notification.Name("gameTimeLeftNotification")
    static let scoreNotification = Notification.Name("scoreNotification")

    // LevelDesignerSaveLevelViewController
    static let notAlphanumericLevelNameNotification =
        Notification.Name("notAlphanumericLevelNameNotification")
    static let levelNameExistsNotification = Notification.Name("levelNameExistsNotification")
    static let levelNameIsPreloadedLevelNotification =
        Notification.Name("levelNameIsPreloadedLevelNotification")
    static let levelSavedNotification = Notification.Name("levelSavedNotification")
    static let levelSaveFailedNotification = Notification.Name("levelSaveFailedNotification")

    // LevelSelectorViewController
    static let levelLoadedNotification = Notification.Name("levelLoadedNotification")
}
