//
//  LevelSelectorViewCell.swift
//  Peggle
//
//  Created by Zhang Cheng on 31/1/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

class LevelSelectorViewCell: UITableViewCell {

    @IBOutlet var displayedLevelName: UITextField!
    var levelName: String = "" {
        didSet {
            self.displayedLevelName.text = levelName
        }
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
}
