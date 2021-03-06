//
//  LevelDesignerViewController.swift
//  Peggle
//
//  Created by Zhang Cheng on 23/1/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

class LevelDesignerViewController: UIViewController {

    // Model variables
    var pegBoardLevel = PegBoardLevel()
    var isSavedLevel = false

    // View variables
    @IBOutlet private var pegBoardView: UICollectionView!

    @IBOutlet private var bluePegButton: UIButton!
    @IBOutlet private var orangePegButton: UIButton!
    @IBOutlet private var greenPegButton: UIButton!

    @IBOutlet private var increasePegSizeButton: UIButton!
    @IBOutlet private var decreasePegSizeButton: UIButton!
    @IBOutlet private var deletePegButton: UIButton!

    @IBOutlet private var loadButton: UIButton!
    @IBOutlet private var saveButton: UIButton!
    @IBOutlet private var resetButton: UIButton!
    @IBOutlet private var startButton: UIButton!

    @IBOutlet private var numBluePegsLabel: UILabel!
    @IBOutlet private var numOrangePegsLabel: UILabel!
    @IBOutlet private var numGreenPegsLabel: UILabel!

    // Controller variables
    enum PegButton: String {
        case blue
        case orange
        case green
        case increaseSize
        case decreaseSize
        case delete
    }
    private var currentPegButtonSelected: PegButton = .blue

    private var musicPlayer = MusicPlayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.pegBoardView.frame = CGRect(x: CGFloat(0), y: NumberConstants.cannonHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)

        if isSavedLevel {
            self.loadPegBoard()
        } else {
            pegBoardLevel = PegBoardLevel(boardWidth:
                pegBoardView.frame.width, boardHeight: pegBoardView.frame.height)
        }

        self.pegBoardView.isUserInteractionEnabled = true

        // Add tap handler for peg board to add/delete a peg
        let pegBoardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LevelDesignerViewController
           .handlePegBoardTap(recognizer:)))
        self.setUpHandlePegBoardTap(pegBoardTapGestureRecognizer: pegBoardTapGestureRecognizer)

        // Add pan handler for peg board to drag a peg around
        let pegBoardPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(LevelDesignerViewController
           .handlePegBoardPan(recognizer:)))
        self.setUpHandlePegBoardPan(pegBoardPanGestureRecognizer: pegBoardPanGestureRecognizer)

        // Add long press handler for peg board to delete a peg
        let pegBoardLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(LevelDesignerViewController
           .handlePegBoardLongPress(recognizer:)))
        self.setUpHandlePegBoardLongPress(pegBoardLongPressGestureRecognizer: pegBoardLongPressGestureRecognizer)

        // Blue peg button is selected by default at first
        self.loadPegButtons()

        self.displayNumOfPegs()
    }

    override func viewDidAppear(_ animated: Bool) {
        musicPlayer.playBackgroundMusic(fileName:
            StringConstants.gameBackgroundMusicPath)
    }

    override func viewDidDisappear(_ animated: Bool) {
        musicPlayer.stopMusicPlayer()
    }

    private func loadPegBoard() {
        for view in pegBoardView.subviews {
            guard let _ = view as? PegView else {
                continue
            }

            view.removeFromSuperview()
        }

        // Get the positions of pegs on the peg board from the `Model` component
        // and creating the `View` components to display the peg board
        for peg in pegBoardLevel.getPegs() {
            let pegPosition = pegBoardLevel.getPegPosition(targetPeg: peg)
            let pegRadius = peg.radius

            let pegView = PegView(frame: CGRect(x: pegPosition.x - pegRadius,
                y: pegPosition.y - pegRadius, width: pegRadius * 2, height: pegRadius * 2))
            pegView.pegColor = peg.color
            pegBoardView.addSubview(pegView)
        }
    }

    private func setUpHandlePegBoardTap(pegBoardTapGestureRecognizer: UITapGestureRecognizer) {
        pegBoardTapGestureRecognizer.numberOfTouchesRequired = 1
        self.pegBoardView.addGestureRecognizer(pegBoardTapGestureRecognizer)
    }

    @objc func handlePegBoardTap(recognizer: UITapGestureRecognizer) {
        let tapPosition = recognizer.location(in: pegBoardView)

        switch self.currentPegButtonSelected {
        case .blue, .orange, .green:
            if self.currentPegButtonSelected == .blue {
                guard pegBoardLevel.addPeg(position: tapPosition, color: .blue) else {
                    return
                }

                self.loadPegBoard()
            } else if self.currentPegButtonSelected == .orange {
                guard pegBoardLevel.addPeg(position: tapPosition, color: .orange) else {
                    return
                }

                self.loadPegBoard()
            } else {
                guard pegBoardLevel.addPeg(position: tapPosition, color: .green) else {
                    return
                }

                self.loadPegBoard()
            }

        case .increaseSize:
            guard pegBoardLevel.increasePegSize(position: tapPosition) else {
                return
            }

            self.loadPegBoard()

        case .decreaseSize:
            guard pegBoardLevel.decreasePegSize(position: tapPosition) else {
                return
            }

            self.loadPegBoard()

        case .delete:
            guard pegBoardLevel.removePeg(position: tapPosition) else {
                return
            }

            self.loadPegBoard()
        }

        self.displayNumOfPegs()
    }

    private func setUpHandlePegBoardPan(pegBoardPanGestureRecognizer: UIPanGestureRecognizer) {
        self.pegBoardView.addGestureRecognizer(pegBoardPanGestureRecognizer)
    }

    private var startingPosition: CGPoint?
    @objc func handlePegBoardPan(recognizer: UIPanGestureRecognizer) {
        let tapPosition = recognizer.location(in: pegBoardView)

        switch recognizer.state {
        case .began:
            startingPosition = tapPosition
        case .changed:
            guard let startingPositionCopy = startingPosition else {
                return
            }

            let translation = recognizer.translation(in: pegBoardView)
            let newPosition = CGPoint(x: startingPositionCopy.x + translation.x, y:
                startingPositionCopy.y + translation.y)

            guard pegBoardLevel.movePeg(oldPosition: startingPositionCopy, newPosition: newPosition) else {
                return
            }

            startingPosition = newPosition
            recognizer.setTranslation(CGPoint.zero, in: pegBoardView)

            self.loadPegBoard()
        case .ended:
            startingPosition = nil
        default:
            return
        }

        self.displayNumOfPegs()
    }

    private func setUpHandlePegBoardLongPress(
        pegBoardLongPressGestureRecognizer: UILongPressGestureRecognizer) {
        self.pegBoardView
            .addGestureRecognizer(pegBoardLongPressGestureRecognizer)
    }

    @objc func handlePegBoardLongPress(recognizer: UILongPressGestureRecognizer) {
        let tapPosition = recognizer.location(in: pegBoardView)

        guard pegBoardLevel.removePeg(position: tapPosition) else {
            return
        }

        self.loadPegBoard()

        self.displayNumOfPegs()
    }

    @IBAction private func handleBluePegButtonTap(_ sender: UIButton) {
        self.currentPegButtonSelected = .blue
        self.loadPegButtons()
    }

    @IBAction private func handleOrangePegButtonTap(_ sender: UIButton) {
        self.currentPegButtonSelected = .orange
        self.loadPegButtons()
    }

    @IBAction private func handleGreenPegButtonTap(_ sender: UIButton) {
        self.currentPegButtonSelected = .green
        self.loadPegButtons()
    }

    @IBAction private func handleIncreasePegSizeButtonTap(_ sender: UIButton) {
        self.currentPegButtonSelected = .increaseSize
        self.loadPegButtons()
    }

    @IBAction private func handleDecreasePegSizeButtonTap(_ sender: UIButton) {
        self.currentPegButtonSelected = .decreaseSize
        self.loadPegButtons()
    }

    @IBAction private func handleDeletePegButtonTap(_ sender: UIButton) {
        self.currentPegButtonSelected = .delete
        self.loadPegButtons()
    }

    @IBAction private func handleSaveButtonTap(_ sender: UIButton) {
        // If peg board does not have at least an orange peg, the level cannot be saved
        if !self.checkPegBoardHasOrangePeg() {
            self.alertNoOrangePeg()
            return
        }

        let levelDesignerSaveLevelViewController =
            createLevelDesignerSaveLevelViewController(previousLevelName:
            pegBoardLevel.levelName, pegBoardLevel: pegBoardLevel)

        // Segue to `LevelDesignerSaveLevelViewController`
        show(levelDesignerSaveLevelViewController, sender: sender)
    }

    // Checks if there is at least an orange peg on the peg board
    private func checkPegBoardHasOrangePeg() -> Bool {
        for peg in pegBoardLevel.pegBoard.pegs where peg.color == .orange {
            return true
        }

        return false
    }

    private func alertNoOrangePeg() {
        let noOrangePegAlert = UIAlertController(title: StringConstants.error, message:
            StringConstants.noOrangePegAlert,
            preferredStyle: .alert)

        noOrangePegAlert
            .addAction(UIAlertAction(title: StringConstants.ok,
            style: .cancel))

        present(noOrangePegAlert, animated: true)
    }

    private func createLevelDesignerSaveLevelViewController(previousLevelName: String?, pegBoardLevel: PegBoardLevel) ->
        LevelDesignerSaveLevelViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let levelDesignerSaveLevelViewController = storyboard
            .instantiateViewController(withIdentifier: Keys
            .levelDesignerSaveLevelViewControllerKey.rawValue)
            as! LevelDesignerSaveLevelViewController

        levelDesignerSaveLevelViewController.pegBoardLevel = pegBoardLevel
        levelDesignerSaveLevelViewController.delegate = self

        return levelDesignerSaveLevelViewController
    }

    // If the level is saved in the `LevelDesignerSaveLevelViewController`, then get the
    // level name from it to update the property in the pegBoardLevel
    func receiveDataFromSaveLevelViewController(pegBoardLevel: PegBoardLevel) {
        self.pegBoardLevel = pegBoardLevel
    }

    @IBAction private func handleResetButtonTap(_ sender: UIButton) {
        guard pegBoardLevel.resetPegBoard() else {
            return
        }

        self.loadPegBoard()

        self.displayNumOfPegs()
    }

    private func displayNumOfPegs() {
        guard let numBluePegs = pegBoardLevel.getNumPegs()[.blue],
            let numOrangePegs = pegBoardLevel.getNumPegs()[.orange],
            let numGreenPegs = pegBoardLevel.getNumPegs()[.green] else {
            return
        }

        numBluePegsLabel.text = String(numBluePegs)
        numOrangePegsLabel.text = String(numOrangePegs)
        numGreenPegsLabel.text = String(numGreenPegs)
    }

    @IBAction private func handleStartButtonTap(_ sender: UIButton) {
        // If peg board does not have at least an orange peg, the level cannot be played
        if !self.checkPegBoardHasOrangePeg() {
            self.alertNoOrangePeg()
            return
        }

        let gameViewController =
            createPeggleGameViewController(pegBoardLevel: self.pegBoardLevel)

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

    private func loadPegButtons() {
        switch self.currentPegButtonSelected {
        case .blue:
            self.bluePegButton.alpha = 1
            self.orangePegButton.alpha = 0.5
            self.greenPegButton.alpha = 0.5
            self.increasePegSizeButton.alpha = 0.5
            self.decreasePegSizeButton.alpha = 0.5
            self.deletePegButton.alpha = 0.5
        case .orange:
            self.bluePegButton.alpha = 0.5
            self.orangePegButton.alpha = 1
            self.greenPegButton.alpha = 0.5
            self.increasePegSizeButton.alpha = 0.5
            self.decreasePegSizeButton.alpha = 0.5
            self.deletePegButton.alpha = 0.5
        case .green:
            self.bluePegButton.alpha = 0.5
            self.orangePegButton.alpha = 0.5
            self.greenPegButton.alpha = 1
            self.increasePegSizeButton.alpha = 0.5
            self.decreasePegSizeButton.alpha = 0.5
            self.deletePegButton.alpha = 0.5
        case .increaseSize:
            self.bluePegButton.alpha = 0.5
            self.orangePegButton.alpha = 0.5
            self.greenPegButton.alpha = 0.5
            self.increasePegSizeButton.alpha = 1
            self.decreasePegSizeButton.alpha = 0.5
            self.deletePegButton.alpha = 0.5
        case .decreaseSize:
            self.bluePegButton.alpha = 0.5
            self.orangePegButton.alpha = 0.5
            self.greenPegButton.alpha = 0.5
            self.increasePegSizeButton.alpha = 0.5
            self.decreasePegSizeButton.alpha = 1
            self.deletePegButton.alpha = 0.5
        case .delete:
            self.bluePegButton.alpha = 0.5
            self.orangePegButton.alpha = 0.5
            self.greenPegButton.alpha = 0.5
            self.increasePegSizeButton.alpha = 0.5
            self.decreasePegSizeButton.alpha = 0.5
            self.deletePegButton.alpha = 1
        }
    }
}
