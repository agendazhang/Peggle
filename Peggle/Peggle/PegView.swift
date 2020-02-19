//
//  PegViewCell.swift
//  Peggle
//
//  Created by Zhang Cheng on 25/1/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

class PegView: UIImageView {

    var pegColor: PegColor = PegColor.blue {
        didSet {
            self.image = PegView.getPegImage(pegColor: pegColor)
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
        case .blue: return UIImage(named: StringConstants.bluePegImagePath)
        case .orange: return UIImage(named:
            StringConstants.orangePegImagePath)
        }
    }
}
