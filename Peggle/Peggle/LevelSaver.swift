//
//  LevelSaver.swift
//  Peggle
//
//  Created by Zhang Cheng on 27/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import Foundation

class LevelSaver {
    func checkSaveLevel(levelName: String, pegBoard: PegBoard) {
        // Level name cannot be empty and must be alphanumeric. Spaces in
        // between letters are not allowed. Leading and trailing whitespaces
        // will be trimmed.
        guard levelName.isAlphanumeric() else {
            NotificationCenter.default.post(name: .notAlphanumericLevelNameNotification,
                object: nil)
            return
        }

        guard !levelNameExists(levelName: levelName) else {
            let levelNameDict: [String: String] = [Keys.levelNameKey.rawValue: levelName]
            NotificationCenter.default.post(name: .levelNameExistsNotification,
                object: nil, userInfo: levelNameDict)
            return
        }

        self.saveLevel(levelName: levelName, pegBoard: pegBoard)
    }

    private func levelNameExists(levelName: String) -> Bool {
        let fileManager = FileManager.default
        do {
            // Load all the file names and check if level name already exists
            let contents = try fileManager
                .contentsOfDirectory(atPath: FileUtility.getDocumentsDirectory())
            return contents
                .contains(levelName + StringConstants.plistFileExtension)
        } catch {
            print(StringConstants.documentFolderDoesNotExist)
            return false
        }
    }

    func saveLevel(levelName: String, pegBoard: PegBoard) {
        do {
            let data = try NSKeyedArchiver
                .archivedData(withRootObject:
                pegBoard, requiringSecureCoding: false)

            // Encode data to a file in the local Documents directory
            try data.write(to: URL(fileURLWithPath:
                FileUtility.fileURLInDocumentsDirectory(fileName:
                levelName, fileExtension: StringConstants
                .plistFileExtension)))

            // Post notification that level is successfully saved
            NotificationCenter.default.post(name: .levelSavedNotification, object: nil)
            return
        } catch {
            // Post notification that level failed to save
            NotificationCenter.default.post(name: .levelSaveFailedNotification, object: nil)
            return
        }
    }
}
