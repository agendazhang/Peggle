//
//  NotificationNameExtensions.swift
//  Peggle
//
//  Created by Zhang Cheng on 21/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let winGameNotification = Notification.Name("winGameNotification")
    static let loseGameNotification = Notification.Name("loseGameNotification")
    static let numOrangePegsRemainingNotification =
        Notification.Name("numOrangePegsRemainingNotification")
    static let numCannonBallsRemainingNotification =
        Notification.Name("numCannonBallsRemainingNotification")
}
