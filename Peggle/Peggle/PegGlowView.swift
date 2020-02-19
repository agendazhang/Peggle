//
//  PegGlowView.swift
//  Peggle
//
//  Created by Zhang Cheng on 10/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

class PegGlowView: UIImageView {

    var pegColor: PegColor = PegColor.blue {
        didSet {
            self.image = PegGlowView.getPegImage(pegColor: pegColor)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }

    static func getPegImage(pegColor: PegColor) -> UIImage? {
        switch pegColor {
        case .blue: return UIImage(named: StringConstants.bluePegGlowImagePath)
        case .orange: return UIImage(named:
            StringConstants.orangePegGlowImagePath)
        }
    }
}
