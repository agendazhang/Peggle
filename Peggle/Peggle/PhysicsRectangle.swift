//
//  PhysicsRectangle.swift
//  Peggle
//
//  Created by Zhang Cheng on 7/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

protocol PhysicsRectangle: PhysicsObject {
    var width: CGFloat { get set }
    var height: CGFloat { get set }
}
