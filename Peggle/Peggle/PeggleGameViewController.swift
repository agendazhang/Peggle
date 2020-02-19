//
//  PeggleGameViewController.swift
//  Peggle
//
//  Created by Zhang Cheng on 8/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

class PeggleGameViewController: UIViewController {

    var pegBoardModel = PegBoardModel()
    var gameEngine: PeggleGameEngine!

    @IBOutlet private var gameBoardView: UICollectionView!
    @IBOutlet private var cannonView: UIImageView!

    override func viewDidLoad() {
        self.gameBoardView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width +
            NumberConstants.cannonHeight)

        self.gameBoardView.isUserInteractionEnabled = true

        // Add tap handler for game board to shoot cannon ball
        let gameBoardTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PeggleGameViewController
           .handleGameBoardTap(recognizer:)))
        self.setUpHandleGameBoardTap(gameBoardTapGestureRecognizer: gameBoardTapGestureRecognizer)

        // Add pan handler for game board to change angle of cannon
        let gameBoardPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(PeggleGameViewController
           .handleGameBoardPan(recognizer:)))
        self.setUpHandleGameBoardPan(gameBoardPanGestureRecognizer: gameBoardPanGestureRecognizer)

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
        let peggleGameEngine = PeggleGameEngine(pegBoardModel: pegBoardModel, gameBoardView:
            gameBoardView)
        self.gameEngine = peggleGameEngine
        peggleGameEngine.startGame()
    }
}
