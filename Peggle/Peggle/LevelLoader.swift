//
//  LevelLoader.swift
//  Peggle
//
//  Created by Zhang Cheng on 27/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import Foundation
import UIKit

class LevelLoader {
    private var boardWidth: CGFloat
    private var boardHeight: CGFloat

    init(boardWidth: CGFloat, boardHeight: CGFloat) {
        self.boardWidth = boardWidth
        self.boardHeight = boardHeight
    }

    func loadLevels() {
        self.loadPreloadedLevels()
        self.loadSavedLevels()
    }

    private func loadPreloadedLevels() {
        let preloadedLevelNames = self.loadPreloadedLevelNames()

        for levelName in preloadedLevelNames {
            // Get the directory of the file in the preloaded level folder
            guard let filePath =  Bundle.main.path(forResource: levelName, ofType:
                StringConstants.plistFileExtension) else {
                return
            }

            guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath))
                else {
                continue
            }

            do {
                // Decode the data from the file
                if let pegBoard = try NSKeyedUnarchiver
                    .unarchiveTopLevelObjectWithData(data) as? PegBoard {

                    let scaledPegBoard = self.scalePegBoardBasedOnBoardSize(pegBoard:
                        pegBoard)

                    let savedLevel = PegBoardLevel(pegBoard: scaledPegBoard, levelName:
                        levelName)

                    let pegBoardLevelDict: [String: PegBoardLevel] =
                        [Keys.pegBoardLevelKey.rawValue: savedLevel]
                    // Post notification that level is successfully loaded
                    NotificationCenter.default.post(name: .levelLoadedNotification,
                        object: nil, userInfo: pegBoardLevelDict)
                }
            } catch {
                print(StringConstants.errorLoadingSavedLevels)
                return
            }
        }
    }

    private func loadPreloadedLevelNames() -> [String] {
        let preloaded1 = StringConstants.preloaded1
        let preloaded2 = StringConstants.preloaded2
        let preloaded3 = StringConstants.preloaded3

        return [preloaded1, preloaded2, preloaded3]
    }

    // The preloaded levels should be completely independent of iPad screen sizes, i.e. pegs
    // should be scaled and positioned in exactly the same way no matter what iPad the user
    // is using
    private func scalePegBoardBasedOnBoardSize(pegBoard: PegBoard) -> PegBoard {
        let scaledPegBoard = PegBoard(boardWidth: self.boardWidth, boardHeight:
            self.boardHeight)

        for peg in pegBoard.pegs {
            let scaledPegX = peg.x * self.boardWidth / NumberConstants.defaultBoardWidth
            let scaledPegY = peg.y * self.boardHeight / NumberConstants.defaultBoardHeight

            guard scaledPegBoard.addPeg(position: CGPoint(x: scaledPegX, y: scaledPegY),
                color: peg.color) else {
                continue
            }
        }

        return scaledPegBoard
    }

    private func loadSavedLevels() {
        let fileManager = FileManager.default
        do {
            // Get all the files of the saved levels from the local directory
            let contents = try fileManager
                .contentsOfDirectory(atPath: FileUtility.getDocumentsDirectory())

            for file in contents {
                let fileURL = FileUtility.getDocumentsDirectory() + "/" + file
                guard let data = try? Data(contentsOf: URL(fileURLWithPath: fileURL))
                    else {
                    continue
                }

                // Decode the data from the file
                if let pegBoard = try NSKeyedUnarchiver
                    .unarchiveTopLevelObjectWithData(data) as? PegBoard {
                    let levelName = file.trimmingCharacters(
                        in: CharacterSet(charactersIn: StringConstants.plistFileExtension))
                    let savedLevel = PegBoardLevel(pegBoard: pegBoard, levelName: levelName)

                    let pegBoardLevelDict: [String: PegBoardLevel] =
                        [Keys.pegBoardLevelKey.rawValue: savedLevel]
                    // Post notification that level is successfully loaded
                    NotificationCenter.default.post(name: .levelLoadedNotification,
                        object: nil, userInfo: pegBoardLevelDict)
                }
            }
        } catch {
            print(StringConstants.errorLoadingSavedLevels)
            return
        }
    }
}
