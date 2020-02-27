//
//  LevelLoader.swift
//  Peggle
//
//  Created by Zhang Cheng on 27/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import Foundation

class LevelLoader {
    func loadLevels() {
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
