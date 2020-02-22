//
//  PeggleGameViewController.swift
//  Peggle
//
//  Created by Zhang Cheng on 8/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

class PeggleGameViewController: UIViewController {

    var pegBoardLevel = PegBoardLevel()
    var gameEngine: PeggleGameEngine!

    @IBOutlet private var gameBoardView: UICollectionView!
    @IBOutlet private var cannonView: UIImageView!
    @IBOutlet private var numOrangePegsRemainingLabel: UILabel!
    @IBOutlet private var numCannonBallsRemainingLabel: UILabel!
    @IBOutlet private var freeBallAnimationLabel: UILabel!

    override func viewDidLoad() {
        self.gameBoardView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width +
            NumberConstants.cannonHeight + NumberConstants.bucketHeight)

        self.gameBoardView.isUserInteractionEnabled = true

        // Add tap handler for game board to shoot cannon ball
        let gameBoardTapGestureRecognizer = UITapGestureRecognizer(target: self, action:
            #selector(PeggleGameViewController
           .handleGameBoardTap(recognizer:)))
        self.setUpHandleGameBoardTap(gameBoardTapGestureRecognizer: gameBoardTapGestureRecognizer)

        // Add pan handler for game board to change angle of cannon
        let gameBoardPanGestureRecognizer = UIPanGestureRecognizer(target: self, action:
            #selector(PeggleGameViewController
           .handleGameBoardPan(recognizer:)))
        self.setUpHandleGameBoardPan(gameBoardPanGestureRecognizer: gameBoardPanGestureRecognizer)

        // To get notification on whether the game is won or lose
        NotificationCenter.default.addObserver(self, selector: #selector(winGame(_:)),
            name: .winGameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loseGame(_:)),
            name: .loseGameNotification, object: nil)

        // To get notification of the number of orange pegs remaining
        NotificationCenter.default.addObserver(self, selector:
            #selector(updateNumOrangePegsRemaining(_:)), name:
            .numOrangePegsRemainingNotification, object: nil)

        // To get notification of the number of cannon balls remaining
        NotificationCenter.default.addObserver(self, selector:
            #selector(updateNumCannonBallsRemaining(_:)), name:
            .numCannonBallsRemainingNotification, object: nil)

        // To get notification to display free ball animation
        NotificationCenter.default.addObserver(self, selector:
            #selector(displayFreeBallAnimation(_:)), name:
            .freeBallNotification, object: nil)

        startGame()
    }

    private func setUpHandleGameBoardTap(gameBoardTapGestureRecognizer: UITapGestureRecognizer) {
        gameBoardTapGestureRecognizer.numberOfTouchesRequired = 1
        self.gameBoardView.addGestureRecognizer(gameBoardTapGestureRecognizer)
    }

    @objc func handleGameBoardTap(recognizer: UITapGestureRecognizer) {
        gameEngine.fireCannon(cannonAngle: cannonAngle)
    }

    private func setUpHandleGameBoardPan(gameBoardPanGestureRecognizer: UIPanGestureRecognizer) {
        self.gameBoardView.addGestureRecognizer(gameBoardPanGestureRecognizer)
    }

    var cannonAngle: CGFloat = 0
    @objc func handleGameBoardPan(recognizer: UIPanGestureRecognizer) {
        let angle = atan2(recognizer.location(in: gameBoardView).y - cannonView.center.y,
            recognizer.location(in: gameBoardView).x - cannonView.center.x)
            - CGFloat(Double.pi / 2)
        cannonAngle = angle
        cannonView.transform = CGAffineTransform(rotationAngle: angle)
    }

    @IBAction private func handleHomeButtonTap(_ sender: UIButton) {
        self.gameEngine.endGame()
    }

    private func startGame() {
        let peggleGameEngine = PeggleGameEngine(pegBoardLevel: pegBoardLevel, gameBoardView:
            gameBoardView)
        self.gameEngine = peggleGameEngine
        peggleGameEngine.startGame()
    }

    @objc private func winGame(_ notification: Notification) {
        let winGameAlert = UIAlertController(title: StringConstants.success, message:
            StringConstants.winGameAlert,
            preferredStyle: .alert)

        winGameAlert
            .addAction(UIAlertAction(title: StringConstants.ok,
            style: .default) {
                [weak self] (_) -> Void in self?
                .segueToMainMenuViewController()
        })

        present(winGameAlert, animated: true)
    }

    @objc private func loseGame(_ notification: Notification) {
        let loseGameAlert = UIAlertController(title: StringConstants.failed, message:
            StringConstants.loseGameAlert,
            preferredStyle: .alert)

        loseGameAlert
            .addAction(UIAlertAction(title: StringConstants.ok,
            style: .default) {
                [weak self] (_) -> Void in self?
                .segueToMainMenuViewController()
        })

        present(loseGameAlert, animated: true)
    }

    private func segueToMainMenuViewController() {
        let mainMenuViewController = createMainMenuViewController()

        // Segue to `MainMenuViewController`
        present(mainMenuViewController, animated: true)
    }

    private func createMainMenuViewController() ->
        MainMenuViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let mainMenuViewController = storyboard
            .instantiateViewController(withIdentifier: Keys
            .mainMenuViewControllerKey.rawValue)
            as! MainMenuViewController

        return mainMenuViewController
    }

    @objc private func updateNumOrangePegsRemaining(_ notification: Notification) {
        if let dict = notification.userInfo as? [String: Int] {
            if let numOrangePegsRemaining = dict[Keys.numOrangePegsRemainingKey.rawValue] {
                numOrangePegsRemainingLabel.text = String(numOrangePegsRemaining)
            }
        }
    }

    @objc private func updateNumCannonBallsRemaining(_ notification: Notification) {
        if let dict = notification.userInfo as? [String: Int] {
            if let numCannonBallsRemaining = dict[Keys.numCannonBallsRemainingKey.rawValue] {
                numCannonBallsRemainingLabel.text = String(numCannonBallsRemaining)
            }
        }
    }

    @objc private func displayFreeBallAnimation(_ notification: Notification) {
        freeBallAnimationLabel.alpha = 1.0

        UIView.animate(withDuration: 1.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.freeBallAnimationLabel.alpha = 0.0
        }, completion: {
            (_: Bool) -> Void in
            self.freeBallAnimationLabel.alpha = 0.0
        })
    }
}
