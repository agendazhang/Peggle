//
//  BucketView.swift
//  Peggle
//
//  Created by Zhang Cheng on 21/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

class BucketView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(named: StringConstants.bucketImagePath)
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
}
