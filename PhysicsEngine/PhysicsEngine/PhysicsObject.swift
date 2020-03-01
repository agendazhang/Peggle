//
//  PhysicsObject.swift
//  Peggle
//
//  Created by Zhang Cheng on 7/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

protocol PhysicsObject: NSObject {
    var uuid: UUID { get set }

    // x and y-coordinates of the center of the object
    var x: CGFloat { get set }
    var y: CGFloat { get set }

    var canMove: Bool { get set }
    var velocity: CGVector { get set }
}
