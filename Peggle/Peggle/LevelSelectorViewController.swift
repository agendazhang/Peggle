//
//  LevelSelectorViewController.swift
//  Peggle
//
//  Created by Zhang Cheng on 30/1/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

class LevelSelectorViewController: UIViewController {

    // Model variables
    var savedLevels: [PegBoardLevel] = []
    var currentLevelSelected = PegBoardLevel()
    var isCurrentLevelSelected = false
    private var levelLoader = LevelLoader()

    // View variables
    @IBOutlet private var displayedLevelNamesTableView: UITableView!

    @IBOutlet private var cancelButton: UIButton!
    @IBOutlet private var editButton: UIButton!
    @IBOutlet private var playButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // To get notification that a level is loaded from file
        NotificationCenter.default.addObserver(self, selector:
            #selector(loadLevel(_:)), name: .levelLoadedNotification, object: nil)

        self.levelLoader.loadLevels()

        self.displayedLevelNamesTableView.dataSource = self
        self.displayedLevelNamesTableView.delegate = self
    }

    @objc private func loadLevel(_ notification: Notification) {
        if let dict = notification.userInfo as? [String: PegBoardLevel] {
            guard let pegBoardLevel = dict[Keys.pegBoardLevelKey.rawValue] else {
                return
            }
            savedLevels.append(pegBoardLevel)
        }
    }

    @IBAction private func handleCancelButtonTap(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction private func handleEditButtonTap(_ sender: UIButton) {
        guard isCurrentLevelSelected else {
            return
        }

        let levelDesignerViewController =
            createLevelDesignerViewController(pegBoardLevel: currentLevelSelected)

        // Segue to `LevelDesignerViewController`
        show(levelDesignerViewController, sender: sender)
    }

    private func createLevelDesignerViewController(pegBoardLevel: PegBoardLevel) ->
        LevelDesignerViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let levelDesignerViewController = storyboard
            .instantiateViewController(withIdentifier: Keys
            .levelDesignerViewControllerKey.rawValue)
            as! LevelDesignerViewController

        levelDesignerViewController.pegBoardLevel = pegBoardLevel

        levelDesignerViewController.isSavedLevel = true

        return levelDesignerViewController
    }

    @IBAction private func handlePlayButtonTap(_ sender: UIButton) {
        guard isCurrentLevelSelected else {
            return
        }

        let gameViewController =
            createPeggleGameViewController(pegBoardLevel: currentLevelSelected)

        // Segue to `LevelDesignerViewController`
        show(gameViewController, sender: sender)
    }

    private func createPeggleGameViewController(pegBoardLevel: PegBoardLevel) ->
        PeggleGameViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let gameViewController = storyboard
            .instantiateViewController(withIdentifier: Keys
            .peggleGameViewControllerKey.rawValue)
            as! PeggleGameViewController

        gameViewController.pegBoardLevel = pegBoardLevel

        return gameViewController
    }
}

// MARK: UITableViewDataSource
extension LevelSelectorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.savedLevels.count
    }

    // Populate the table with names of the saved levels
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let savedLevel = self.savedLevels[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier:
            Keys.levelSelectorViewCellKey.rawValue) as! LevelSelectorViewCell
        if let levelName = savedLevel.levelName {
            cell.levelName = levelName
        }

        return cell
    }

}

// MARK: UITableViewDelegate
extension LevelSelectorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentLevelSelected = savedLevels[indexPath.row]
        isCurrentLevelSelected = true
    }
}
