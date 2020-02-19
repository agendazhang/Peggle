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
    var savedLevels: [PegBoardModel] = []
    var currentLevelSelected = PegBoardModel()
    var isCurrentLevelSelected = false

    // View variables
    @IBOutlet private var displayedLevelNamesTableView: UITableView!

    @IBOutlet private var cancelButton: UIButton!
    @IBOutlet private var editButton: UIButton!
    @IBOutlet private var playButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadSavedLevels()

        self.displayedLevelNamesTableView.dataSource = self
        self.displayedLevelNamesTableView.delegate = self
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
                    let savedLevel = PegBoardModel(pegBoard: pegBoard, levelName: levelName)
                    savedLevels.append(savedLevel)
                }
            }
        } catch {
            print(StringConstants.errorLoadingSavedLevels)
            return
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
            createLevelDesignerViewController(pegBoardModel: currentLevelSelected)

        // Segue to `LevelDesignerViewController`
        show(levelDesignerViewController, sender: sender)
    }

    private func createLevelDesignerViewController(pegBoardModel: PegBoardModel) ->
        LevelDesignerViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let levelDesignerViewController = storyboard
            .instantiateViewController(withIdentifier: Keys
            .levelDesignerViewControllerKey.rawValue)
            as! LevelDesignerViewController

        levelDesignerViewController.pegBoardModel = pegBoardModel

        levelDesignerViewController.isSavedLevel = true

        return levelDesignerViewController
    }

    @IBAction private func handlePlayButtonTap(_ sender: UIButton) {
        guard isCurrentLevelSelected else {
            return
        }

        let gameViewController =
            createPeggleGameViewController(pegBoardModel: currentLevelSelected)

        // Segue to `LevelDesignerViewController`
        show(gameViewController, sender: sender)
    }

    private func createPeggleGameViewController(pegBoardModel: PegBoardModel) ->
        PeggleGameViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let gameViewController = storyboard
            .instantiateViewController(withIdentifier: Keys
            .peggleGameViewControllerKey.rawValue)
            as! PeggleGameViewController

        gameViewController.pegBoardModel = pegBoardModel

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
