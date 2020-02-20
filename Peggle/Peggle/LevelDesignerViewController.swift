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
    var pegBoardModel = PegBoardModel()
    var isSavedLevel = false

    // View variables
    @IBOutlet private var pegBoardView: UICollectionView!

    @IBOutlet private var bluePegButton: UIButton!
    @IBOutlet private var orangePegButton: UIButton!
    @IBOutlet private var deletePegButton: UIButton!

    @IBOutlet private var loadButton: UIButton!
    @IBOutlet private var saveButton: UIButton!
    @IBOutlet private var resetButton: UIButton!
    @IBOutlet private var startButton: UIButton!

    // Controller variables
    enum PegButton: String {
        case blue
        case orange
        case delete
    }
    private var currentPegButtonSelected: PegButton = .blue

    override func viewDidLoad() {
        super.viewDidLoad()

        self.pegBoardView.frame = CGRect(x: CGFloat(0), y: NumberConstants.cannonHeight, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)

        if isSavedLevel {
            self.loadPegBoard()
        } else {
            pegBoardModel = PegBoardModel(boardWidth:
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
    }

    private func calculatePegRadius() -> CGFloat {
        let frameWidth = pegBoardView.frame.width
        let frameHeight = pegBoardView.frame.height
        if frameWidth < frameHeight {
            return (frameWidth / 2) / CGFloat(NumberConstants.numPegCols)
        } else {
            return (frameHeight / 2) / CGFloat(NumberConstants.numPegRows)
        }
    }

    private func loadPegBoard() {
        for view in pegBoardView.subviews {
            guard let _ = view as? PegView else {
                continue
            }

            view.removeFromSuperview()
        }

        // Get the positions of pegs on the peg board from the 'Model' component
        // and creating the `View` components to display the peg board
        for peg in pegBoardModel.getPegs() {
            let pegPosition = pegBoardModel.getPegPosition(targetPeg: peg)
            let pegRadius = calculatePegRadius()

            let pegView = PegView(frame: CGRect(x: pegPosition.x - pegRadius,
                y: pegPosition.y - pegRadius, width: calculatePegRadius() * 2, height:
                calculatePegRadius() * 2))
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
        case .blue, .orange:
            if self.currentPegButtonSelected == .blue {
                guard pegBoardModel.addPeg(position: tapPosition, color: .blue) else {
                    return
                }

                self.loadPegBoard()
            } else {
                guard pegBoardModel.addPeg(position: tapPosition, color: .orange) else {
                    return
                }

                self.loadPegBoard()
            }

        case .delete:
            guard pegBoardModel.removePeg(position: tapPosition) else {
                return
            }

            self.loadPegBoard()
        }
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

            guard pegBoardModel.movePeg(oldPosition: startingPositionCopy, newPosition: newPosition) else {
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
    }

    private func setUpHandlePegBoardLongPress(
        pegBoardLongPressGestureRecognizer: UILongPressGestureRecognizer) {
        self.pegBoardView
            .addGestureRecognizer(pegBoardLongPressGestureRecognizer)
    }

    @objc func handlePegBoardLongPress(recognizer: UILongPressGestureRecognizer) {
        let tapPosition = recognizer.location(in: pegBoardView)

        guard pegBoardModel.removePeg(position: tapPosition) else {
            return
        }

        self.loadPegBoard()
    }

    @IBAction private func handleBluePegButtonTap(_ sender: UIButton) {
        self.currentPegButtonSelected = .blue
        self.loadPegButtons()
    }

    @IBAction private func handleOrangePegButtonTap(_ sender: UIButton) {
        self.currentPegButtonSelected = .orange
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
            pegBoardModel.levelName, pegBoardModel: pegBoardModel)

        // Segue to `LevelDesignerSaveLevelViewController`
        show(levelDesignerSaveLevelViewController, sender: sender)
    }

    // Checks if there is at least an orange peg on the peg board
    private func checkPegBoardHasOrangePeg() -> Bool {
        for peg in pegBoardModel.pegBoard.pegs where peg.color == .orange {
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

    private func createLevelDesignerSaveLevelViewController(previousLevelName: String?, pegBoardModel: PegBoardModel) ->
        LevelDesignerSaveLevelViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let levelDesignerSaveLevelViewController = storyboard
            .instantiateViewController(withIdentifier: Keys
            .levelDesignerSaveLevelViewControllerKey.rawValue)
            as! LevelDesignerSaveLevelViewController

        levelDesignerSaveLevelViewController.pegBoardModel = pegBoardModel
        levelDesignerSaveLevelViewController.delegate = self

        return levelDesignerSaveLevelViewController
    }

    // If the level is saved in the `LevelDesignerSaveLevelViewController`, then get the
    // level name from it to update the property in the pegBoardModel
    func receiveDataFromSaveLevelViewController(pegBoardModel: PegBoardModel) {
        self.pegBoardModel = pegBoardModel
    }

    @IBAction private func handleResetButtonTap(_ sender: UIButton) {
        guard pegBoardModel.resetPegBoard() else {
            return
        }

        self.loadPegBoard()
    }

    @IBAction private func handleStartButtonTap(_ sender: UIButton) {
        // If peg board does not have at least an orange peg, the level cannot be played
        if !self.checkPegBoardHasOrangePeg() {
            self.alertNoOrangePeg()
            return
        }

        let gameViewController =
            createPeggleGameViewController(pegBoardModel: self.pegBoardModel)

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

    private func loadPegButtons() {
        switch self.currentPegButtonSelected {
        case .blue:
            self.bluePegButton.alpha = 1
            self.orangePegButton.alpha = 0.5
            self.deletePegButton.alpha = 0.5
        case .orange:
            self.bluePegButton.alpha = 0.5
            self.orangePegButton.alpha = 1
            self.deletePegButton.alpha = 0.5
        case .delete:
            self.bluePegButton.alpha = 0.5
            self.orangePegButton.alpha = 0.5
            self.deletePegButton.alpha = 1
        }
    }
}
