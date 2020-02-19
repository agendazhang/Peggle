//
//  CannonBallView.swift
//  Peggle
//
//  Created by Zhang Cheng on 9/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

class CannonBallView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(named: StringConstants.cannonBallImagePath)
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
}
