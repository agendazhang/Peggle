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
    private var levelSaver: LevelSaver = LevelSaver()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setSavedLevelName()

        // To get notification that level name is not alphanumeric
        NotificationCenter.default.addObserver(self, selector:
            #selector(alertNotAlphanumericLevelName(_:)), name:
            .notAlphanumericLevelNameNotification, object: nil)

        // To get notification that level name already exists
        NotificationCenter.default.addObserver(self, selector:
            #selector(alertLevelNameExists(_:)), name:
            .levelNameExistsNotification, object: nil)

        // To get notification that level name belongs to preloaded level
        NotificationCenter.default.addObserver(self, selector:
            #selector(alertLevelNameIsPreloadedLevel(_:)), name:
            .levelNameIsPreloadedLevelNotification, object: nil)

        // To get notification that level is successfully saved
        NotificationCenter.default.addObserver(self, selector:
            #selector(alertLevelSaved(_:)), name: .levelSavedNotification, object: nil)

        // To get notification that level failed to save
        NotificationCenter.default.addObserver(self, selector:
            #selector(alertLevelSaveFailed(_:)), name:
            .levelSaveFailedNotification, object: nil)
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

        self.levelSaver.checkSaveLevel(levelName: levelName, pegBoard:
            pegBoardLevel.pegBoard)
    }

    @objc private func alertNotAlphanumericLevelName(_ notification: Notification) {
        let notAlphanumericLevelNameAlert = UIAlertController(title: StringConstants.error, message:
            StringConstants.notAlphanumericLevelNameAlert,
            preferredStyle: .alert)

        notAlphanumericLevelNameAlert
            .addAction(UIAlertAction(title: StringConstants.ok,
            style: .cancel))

        present(notAlphanumericLevelNameAlert, animated: true)
    }

    // Asks the user if he wants to override an existing level with same name
    @objc private func alertLevelNameExists(_ notification: Notification) {

        if let dict = notification.userInfo as? [String: String] {
            guard let levelName = dict[Keys.levelNameKey.rawValue] else {
                return
            }
            let levelNameExistsAlert = UIAlertController(title: StringConstants.error, message: StringConstants.levelNameExistsAlert, preferredStyle: .alert)

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
    }

    @objc private func alertLevelNameIsPreloadedLevel(_ notification: Notification) {
        let levelNameIsPreloadedLevelAlert = UIAlertController(title: StringConstants.error, message:
            StringConstants.levelNameIsPreloadedLevelAlert,
            preferredStyle: .alert)

        levelNameIsPreloadedLevelAlert
            .addAction(UIAlertAction(title: StringConstants.ok,
            style: .cancel))

        present(levelNameIsPreloadedLevelAlert, animated: true)
    }

    private func saveLevel(levelName: String) {
        self.levelSaver.saveLevel(levelName: levelName, pegBoard: pegBoardLevel.pegBoard)
    }

    @objc private func alertLevelSaved(_ notification: Notification) {
        let levelSavedAlert = UIAlertController(title: StringConstants.success,
            message: StringConstants.levelNameSavedAlert,
            preferredStyle: .alert)

        levelSavedAlert
            .addAction(UIAlertAction(title: StringConstants.ok,
            style: .cancel))

        present(levelSavedAlert, animated: true)
    }

    @objc private func alertLevelSaveFailed(_ notification: Notification) {
        let levelSavedAlert = UIAlertController(title: StringConstants.error,
            message: StringConstants.levelNameSaveFailedAlert,
            preferredStyle: .alert)

        levelSavedAlert.addAction(UIAlertAction(title: StringConstants.ok,
            style: .cancel))

        present(levelSavedAlert, animated: true)
    }

}
