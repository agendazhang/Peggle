//
//  PeggleGameEngine.swift
//  Peggle
//
//  Created by Zhang Cheng on 8/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

class PeggleGameEngine {

    // Model variables
    private (set) var pegBoardModel: PegBoardModel
    private (set) var gameRenderer: PeggleGameRenderer
    private var gameTimer = Timer()
    private (set) var physicsObjects: [PhysicsObject]
    private var canFireCannon: Bool
    private var gameCondition: PeggleGameCondition
    private var pegsHitPerCannonBall: [Peg] = []

    // View variables
    private (set) var gameBoardView: UICollectionView

    init(pegBoardModel: PegBoardModel, gameBoardView: UICollectionView) {
        self.pegBoardModel = pegBoardModel
        self.gameBoardView = gameBoardView

        self.gameRenderer = PeggleGameRenderer(gameBoardView: gameBoardView)
        self.physicsObjects = []
        self.canFireCannon = true
        self.gameCondition = PeggleGameCondition(pegBoardModel: pegBoardModel)
    }

    func addPhysicsObject(physicsObject: PhysicsObject) {
        self.physicsObjects.append(physicsObject)
    }

    func addPhysicsObject(physicsObject: PhysicsObject, image: UIImageView) {
        self.physicsObjects.append(physicsObject)
        self.gameRenderer.addImage(physicsObject: physicsObject, image: image)
    }

    func removePhysicsObject(physicsObject: PhysicsObject) {
        physicsObjects = physicsObjects.filter { $0.uuid != physicsObject.uuid }
        gameRenderer.removeImage(physicsObject: physicsObject)
    }

    func startGame() {
        self.setUpPegs()
        self.setUpWalls()

        // Update the "Orange Pegs Remaining" label with the original count
        let numOrangePegsRemaining = self.gameCondition.getNumOrangePegsRemaining()
        let numOrangePegsRemainingDict: [String: Int] =
            [Keys.numOrangePegsRemainingKey.rawValue: numOrangePegsRemaining]
        NotificationCenter.default.post(name: .numOrangePegsRemainingNotification, object: nil, userInfo: numOrangePegsRemainingDict)

        self.startTimer()
    }

    func endGame() {
        self.endTimer()
    }

    // Based on the position and type of pegs given by `pegBoardModel`, load the game board
    // with these pegs
    private func setUpPegs() {
        for peg in pegBoardModel.pegBoard.pegs {
            // To account for the additional cannon height
            peg.y += NumberConstants.cannonHeight

            let pegPosition = pegBoardModel.getPegPosition(targetPeg: peg)
            let pegRadius = peg.radius

            let pegView = PegView(frame: CGRect(x: pegPosition.x - pegRadius,
                y: pegPosition.y - pegRadius, width: pegRadius * 2, height: pegRadius * 2))
            pegView.pegColor = peg.color

            self.addPhysicsObject(physicsObject: peg, image: pegView)
        }
    }

    // Add the 4 walls that represent the 4 sides of the game board
    private func setUpWalls() {
        let gameBoardViewWidth = gameBoardView.frame.width
        let gameBoardViewHeight = gameBoardView.frame.height

        // For the top and bottom walls, I would put the width as the width of the game
        // board and the height as zero. For the side walls, I would put the width as zero
        // and the height as the height of the game board. The reason I make either the
        // width or height to be zero is because in the actual game, it is assumed that the
        // user would know that whenever the ball collides with the sides of his screen, it
        // would bounce back as if there is a wall there. Hence, the wall that I implemented
        // need not be visually there. With this implementation, the `PhysicsEngine` is
        // still able to detect collision whenever the cannon ball collides with any of the
        // walls.
        let topWall = Wall(x: gameBoardViewWidth / 2, y: 0, wallType: .topWall, width:
            gameBoardViewWidth, height: 0)
        let leftWall = Wall(x: 0, y: gameBoardViewHeight / 2, wallType: .leftWall, width: 0,
            height: gameBoardViewHeight)
        let rightWall = Wall(x: gameBoardViewWidth, y: gameBoardViewHeight / 2,
            wallType: .rightWall, width: 0,
        height: gameBoardViewHeight)
        let bottomWall = Wall(x: gameBoardViewWidth / 2, y: gameBoardViewHeight, wallType:
            .bottomWall, width: gameBoardViewWidth, height: 0)

        self.addPhysicsObject(physicsObject: topWall)
        self.addPhysicsObject(physicsObject: leftWall)
        self.addPhysicsObject(physicsObject: rightWall)
        self.addPhysicsObject(physicsObject: bottomWall)
    }

    // The FPS for the game is 60
    func startTimer() {
        gameTimer = Timer.scheduledTimer(timeInterval:
            TimeInterval(NumberConstants.gameInterval),
            target: self, selector: #selector(gameInterval), userInfo: nil,
            repeats: true)
    }

    func endTimer() {
        gameTimer.invalidate()
    }

    @objc private func gameInterval() {
        let gameCollisionHandler = PeggleGameCollisionHandler(gameEngine: self)
        let physicsEngine = PhysicsEngine(physicsObjects: self.physicsObjects, physicsCollisionHandler: gameCollisionHandler)
        physicsEngine.moveObjects()
        physicsEngine.addGravityToObjects(gravityForce: NumberConstants.gravityForce)

        gameRenderer.moveImages(physicsObjects: physicsObjects)
    }

    func fireCannon(cannonAngle: CGFloat) {
        guard self.cannonAngleIsValid(cannonAngle: cannonAngle) else {
            return
        }

        // When a cannon ball is fired, no other cannon ball is allowed to be fired until the
        // previous ball hits the bottom wall and disappears
        guard self.canFireCannon else {
            return
        }

        guard !self.gameCondition.checkWinGame() && !self.gameCondition.checkLoseGame() else {
            return
        }

        self.canFireCannon = false

        let cannonBallStartingX = gameBoardView.frame.width / 2
        let cannonBallStartingY = NumberConstants.cannonHeight / 2
        let cannonBallRadius = gameBoardView.frame.width /
            CGFloat(NumberConstants.numPegRows) / 2
        let cannonBallVelocity = self.calculateCannonBallStartingVelocity(cannonAngle:
            cannonAngle)

        let cannonBall = CannonBall(x: cannonBallStartingX, y: cannonBallStartingY, radius:
            cannonBallRadius, velocity: cannonBallVelocity)

        let cannonBallView = CannonBallView(frame: CGRect(x: cannonBallStartingX -
            cannonBallRadius, y: cannonBallStartingY - cannonBallRadius, width:
            cannonBallRadius * 2, height: cannonBallRadius * 2))

        self.addPhysicsObject(physicsObject: cannonBall, image: cannonBallView)

        self.gameCondition.loseCannonBall()
    }

    // Cannon ball can only be fired towards the bottom half of the game board
    func cannonAngleIsValid(cannonAngle: CGFloat) -> Bool {
        guard cannonAngle < CGFloat(Double.pi / 2) && cannonAngle > CGFloat(-Double.pi / 2)
            else {
            return false
        }

        return true
    }

    private func calculateCannonBallStartingVelocity(cannonAngle: CGFloat) -> CGVector {
        let dx = NumberConstants.cannonBallStartingVelocity * sin(cannonAngle +
            CGFloat(Double.pi))
        let dy = NumberConstants.cannonBallStartingVelocity * cos(cannonAngle)

        return CGVector(dx: dx, dy: dy)
    }

    func cannonBallHitsPeg(peg: Peg) {
        // If peg has already been hit by cannon ball this round, skip it
        let alreadyHitPeg = pegsHitPerCannonBall.filter { $0.uuid == peg.uuid }
        guard alreadyHitPeg.count == 0 else {
            return
        }

        pegsHitPerCannonBall.append(peg)

        // Light up the pegs that are hit
        let pegGlowView = PegGlowView(frame: CGRect(x: peg.x - peg.radius,
            y: peg.y - peg.radius, width: peg.radius * 2, height: peg.radius * 2))
        pegGlowView.pegColor = peg.color

        self.gameRenderer.changeImage(physicsObject: peg, image: pegGlowView)
    }

    // Allow cannon to be fired again after previous cannon ball hits the bottom wall and
    // disappears
    func cannonBallHitsBottomWall(cannonBall: CannonBall) {
        self.canFireCannon = true
        self.removePhysicsObject(physicsObject: cannonBall)

        self.gameCondition.updateNumOrangePegsRemaining(pegsHitPerCannonBall:
            pegsHitPerCannonBall)

        // Remove the pegs that are hit only after the cannon ball exits the game
        self.removePegsHitPerCannonBall()

        // Update the "Orange Pegs Remaining" label with the new count
        let numOrangePegsRemaining = self.gameCondition.getNumOrangePegsRemaining()
        let numOrangePegsRemainingDict: [String: Int] =
            [Keys.numOrangePegsRemainingKey.rawValue: numOrangePegsRemaining]
        NotificationCenter.default.post(name: .numOrangePegsRemainingNotification, object: nil, userInfo: numOrangePegsRemainingDict)

        if self.gameCondition.checkWinGame() {
            NotificationCenter.default.post(name: .winGameNotification, object: nil)
        }

        if self.gameCondition.checkLoseGame() {
            NotificationCenter.default.post(name: .loseGameNotification, object: nil)
        }
    }

    private func removePegsHitPerCannonBall() {
        pegsHitPerCannonBall.forEach { self.removePhysicsObject(physicsObject: $0) }
        pegsHitPerCannonBall = []
    }
}
