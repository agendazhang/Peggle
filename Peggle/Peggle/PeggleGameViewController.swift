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

    private var musicPlayer = MusicPlayer()

    @IBOutlet private var gameBoardView: UICollectionView!
    @IBOutlet private var cannonView: UIImageView!
    @IBOutlet private var numOrangePegsRemainingLabel: UILabel!
    @IBOutlet private var numCannonBallsRemainingLabel: UILabel!
    @IBOutlet private var gameTimeLeftLabel: UILabel!
    @IBOutlet private var scoreLabel: UILabel!

    @IBOutlet private var animationLabel: UILabel!

    @IBOutlet private var gameEndView: UIView!
    @IBOutlet private var gameEndLabel: UILabel!
    @IBOutlet private var gameEndStatsView: UIView!
    @IBOutlet private var gameEndTimeTakenLabel: UILabel!
    @IBOutlet private var gameEndScoreLabel: UILabel!
    @IBOutlet private var gameEndExitButton: UIButton!

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

        // To get notification of the cannon being fired
        NotificationCenter.default.addObserver(self, selector:
            #selector(playFireCannonSound(_:)), name:
            .fireCannonNotification, object: nil)

        // To get notification of the score
       NotificationCenter.default.addObserver(self, selector:
           #selector(updateScore(_:)), name:
           .scoreNotification, object: nil)

        // To get notification about the free ball after the cannon ball enters the bucket
        NotificationCenter.default.addObserver(self, selector:
            #selector(displayFreeBallAnimation(_:)), name:
            .freeBallNotification, object: nil)

        // To get notification about the space blast
        NotificationCenter.default.addObserver(self, selector:
            #selector(displaySpaceBlastAnimation(_:)), name:
            .spaceBlastNotification, object: nil)

        // To get notification about the spooky ball
        NotificationCenter.default.addObserver(self, selector:
            #selector(displaySpookyBallAnimation(_:)), name:
            .spookyBallNotification, object: nil)

        // To get notification of the game time left
        NotificationCenter.default.addObserver(self, selector:
            #selector(updateGameTimeLeft(_:)), name:
            .gameTimeLeftNotification, object: nil)

        startGame()
    }

    override func viewDidAppear(_ animated: Bool) {
        musicPlayer.playBackgroundMusic(fileName:
            StringConstants.gameBackgroundMusicPath)
    }

    override func viewDidDisappear(_ animated: Bool) {
        musicPlayer.stopMusicPlayer()
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

    @IBAction func handlePlayPauseButtonTap(_ sender: UIButton) {
        self.gameEngine.startPauseTimer()
    }

    private func startGame() {
        let peggleGameEngine = PeggleGameEngine(pegBoardLevel: pegBoardLevel, gameBoardView:
            gameBoardView)
        self.gameEngine = peggleGameEngine
        peggleGameEngine.startGame()
    }

    @objc private func winGame(_ notification: Notification) {
        musicPlayer.playSoundEffect(fileName: StringConstants.winGameSoundPath)

        // End game screen pops up
        self.gameEndView.alpha = 1

        // End game stats screen pops up
        self.gameEndStatsView.alpha = 1

        // Update label to "YOU WIN"
        self.gameEndLabel.text = StringConstants.winGameMessage

        if let dict = notification.userInfo as? [String: Float] {
            // Update "Time Taken" label in end game stats screen
            if let gameTimeLeft = dict[Keys.gameTimeLeftKey.rawValue] {
                gameEndTimeTakenLabel.text = String(format: "%.2f",
                NumberConstants.defaultGameTime - gameTimeLeft)
            }
            // Update "Score" label in end game stats screen
            if let score = dict[Keys.scoreKey.rawValue] {
                gameEndScoreLabel.text = String(Int(score))
            }
        }
    }

    @objc private func loseGame(_ notification: Notification) {
        musicPlayer.playSoundEffect(fileName: StringConstants.loseGameSoundPath)

        // End game screen pops up
        self.gameEndView.alpha = 1

        // Update label to "GAME OVER"
        self.gameEndLabel.text = StringConstants.loseGameMessage
    }

    @IBAction private func handleGameEndExitButtonTap(_ sender: UIButton) {
        // Go back to main menu
        segueToMainMenuViewController()
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

    @objc private func playFireCannonSound(_ notification: Notification) {
        musicPlayer.playSoundEffect(fileName: StringConstants.fireCannonSoundPath)
    }

    @objc private func updateScore(_ notification: Notification) {
        if let dict = notification.userInfo as? [String: Int] {
            if let score = dict[Keys.scoreKey.rawValue] {
                scoreLabel.text = String(score)
            }
        }
    }

    @objc private func displayFreeBallAnimation(_ notification: Notification) {
        musicPlayer.playSoundEffect(fileName: StringConstants.freeBallSoundPath)

        self.animationLabel.alpha = 1.0
        self.animationLabel.text = StringConstants.freeBallAnimation
        self.animationLabel.textColor = .gray

        UIView.animate(withDuration: NumberConstants.animationDuration, delay: 0.0, options:
            .curveEaseOut, animations: {
            self.animationLabel.alpha = 0.0
        }, completion: {
            (_: Bool) -> Void in
            self.animationLabel.alpha = 0.0
        })
    }

    @objc private func displaySpaceBlastAnimation(_ notification: Notification) {
        musicPlayer.playSoundEffect(fileName: StringConstants.spaceBlastSpookyBallSoundPath)

        self.animationLabel.alpha = 1.0
        self.animationLabel.text = StringConstants.spaceBlastAnimation
        self.animationLabel.textColor = .green

        UIView.animate(withDuration: NumberConstants.animationDuration, delay: 0.0, options:
            .curveEaseOut, animations: {
            self.animationLabel.alpha = 0.0
        }, completion: {
            (_: Bool) -> Void in
            self.animationLabel.alpha = 0.0
        })
    }

    @objc private func displaySpookyBallAnimation(_ notification: Notification) {
        musicPlayer.playSoundEffect(fileName: StringConstants.spaceBlastSpookyBallSoundPath)

        self.animationLabel.alpha = 1.0
        self.animationLabel.text = StringConstants.spookyBallAnimation
        self.animationLabel.textColor = .green

        UIView.animate(withDuration: NumberConstants.animationDuration, delay: 0.0, options:
            .curveEaseOut, animations: {
            self.animationLabel.alpha = 0.0
        }, completion: {
            (_: Bool) -> Void in
            self.animationLabel.alpha = 0.0
        })
    }

    @objc private func updateGameTimeLeft(_ notification: Notification) {
        if let dict = notification.userInfo as? [String: Float] {
            if let gameTimeLeft = dict[Keys.gameTimeLeftKey.rawValue] {
                gameTimeLeftLabel.text = String(format: "%.2f", gameTimeLeft)
            }
        }
    }
}
