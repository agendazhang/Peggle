//
//  Keys.swift
//  Peggle
//
//  Created by Zhang Cheng on 24/1/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

enum Keys: String {

    // CirclePeg
    case xKey
    case yKey
    case colorKey
    case radiusKey

    // TrianglePeg
    case centerToVerticeDistKey
    case angleKey

    // PegBoard
    case boardWidthKey
    case boardHeightKey
    case pegsKey

    // PegViewCell
    case pegViewCellKey

    // LevelDesignerViewController
    case levelDesignerSaveLevelViewControllerKey

    // LevelSelectorViewController
    case levelSelectorViewCellKey
    case levelDesignerViewControllerKey
    case peggleGameViewControllerKey

    // PeggleGameViewController
    case levelSelectorViewControllerKey
    case mainMenuViewControllerKey
    case numOrangePegsRemainingKey
    case numCannonBallsRemainingKey
    case gameTimeLeftKey

    // LevelSaver
    case levelNameKey

    // LevelLoader
    case pegBoardLevelKey
}
