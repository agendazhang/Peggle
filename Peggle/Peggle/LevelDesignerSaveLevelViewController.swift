//
//  LevelDesignerSaveLevelViewController.swift
//  Peggle
//
//  Created by Zhang Cheng on 27/1/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

class LevelDesignerSaveLevelViewController: UIViewController {

    var pegBoardLevel = PegBoardLevel()
    weak var delegate: LevelDesignerViewController?
    @IBOutlet private var levelNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setSavedLevelName()
    }

    private func setSavedLevelName() {
        guard let savedLevelName = pegBoardLevel.levelName else {
            return
        }
        self.levelNameTextField.text = savedLevelName
    }

    @IBAction private func handleCancelButtonTap(_ sender: UIButton) {
        if delegate != nil {
            delegate?.receiveDataFromSaveLevelViewController(pegBoardLevel: pegBoardLevel)
        }
        dismiss(animated: true)
    }

    @IBAction private func handleSaveButtonTap(_ sender: UIButton) {

        guard var levelName = self.levelNameTextField.text else {
            return
        }

        levelName = levelName.trimmingCharacters(in: .whitespacesAndNewlines)

        // Level name cannot be empty and must be alphanumeric. Spaces in
        // between letters are not allowed. Leading and trailing whitespaces
        // will be trimmed.
        if !levelName.isAlphanumeric() {
            self.alertNotAlphanumericLevelName()
            return
        }

        if self.levelNameExists(levelName: levelName) {
            self.alertLevelNameExists(levelName: levelName)
            return
        }

        self.saveLevel(levelName: levelName)
    }

    private func alertNotAlphanumericLevelName() {
        let notAlphanumericLevelNameAlert = UIAlertController(title: StringConstants.error, message:
            StringConstants.notAlphanumericLevelNameAlert,
            preferredStyle: .alert)

        notAlphanumericLevelNameAlert
            .addAction(UIAlertAction(title: StringConstants.ok,
            style: .cancel))

        present(notAlphanumericLevelNameAlert, animated: true)
    }

    private func levelNameExists(levelName: String) -> Bool {
        let fileManager = FileManager.default
        do {
            let contents = try fileManager
                .contentsOfDirectory(atPath: FileUtility.getDocumentsDirectory())
            return contents
                .contains(levelName + StringConstants.plistFileExtension)
        } catch {
            print(StringConstants.documentFolderDoesNotExist)
            return false
        }
    }

    // Asks the user if he wants to override an existing level with same name
    private func alertLevelNameExists(levelName: String) {
        let levelNameExistsAlert = UIAlertController(title: StringConstants.error, message:
            StringConstants.levelNameExistsAlert,
            preferredStyle: .alert)

        levelNameExistsAlert
            .addAction(UIAlertAction(title: StringConstants.cancel,
            style: .cancel))
        levelNameExistsAlert
            .addAction(UIAlertAction(title: StringConstants.ok,
            style: .default) {
                [weak self] (_) -> Void in self?
                .saveLevel(levelName: levelName)
        })

        present(levelNameExistsAlert, animated: true)
    }

    private func saveLevel(levelName: String) {
        do {
            let data = try NSKeyedArchiver
                .archivedData(withRootObject:
                pegBoardLevel.pegBoard, requiringSecureCoding: false)

            // Encode data to a file in the local Documents directory
            try data.write(to: URL(fileURLWithPath:
                FileUtility.fileURLInDocumentsDirectory(fileName:
                levelName, fileExtension: StringConstants
                .plistFileExtension)))

            pegBoardLevel.levelName = levelName
            self.alertLevelSaved()
        } catch {
            self.alertLevelSaveFailed()
            return
        }
    }

    private func alertLevelSaved() {
        let levelSavedAlert = UIAlertController(title: StringConstants.success,
            message: StringConstants.levelNameSavedAlert,
            preferredStyle: .alert)

        levelSavedAlert
            .addAction(UIAlertAction(title: StringConstants.ok,
            style: .cancel))

        present(levelSavedAlert, animated: true)
    }

    private func alertLevelSaveFailed() {
        let levelSavedAlert = UIAlertController(title: StringConstants.error,
            message: StringConstants.levelNameSaveFailedAlert,
            preferredStyle: .alert)

        levelSavedAlert.addAction(UIAlertAction(title: StringConstants.ok,
            style: .cancel))

        present(levelSavedAlert, animated: true)
    }

}
