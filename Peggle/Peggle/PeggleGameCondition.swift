//
//  PeggleGameCondition.swift
//  Peggle
//
//  Created by Zhang Cheng on 20/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

class PeggleGameCondition {

    private var numCannonBallsRemaining: Int
    private var numOrangePegsRemaining: Int
    private var gameTimeLeft: Float
    private var score: Int

    init(pegBoardLevel: PegBoardLevel) {
        self.numCannonBallsRemaining = NumberConstants.defaultNumberOfCannonBalls

        var numOrangePegs = 0
        for peg in pegBoardLevel.pegBoard.pegs where peg.color == .orange {
            numOrangePegs += 1
        }
        self.numOrangePegsRemaining = numOrangePegs

        self.gameTimeLeft = NumberConstants.defaultGameTime

        self.score = 0
    }

    func updateNumOrangePegsRemaining(pegsHitPerCannonBall: [Peg]) {
        for peg in pegsHitPerCannonBall where peg.color == .orange {
            numOrangePegsRemaining -= 1
        }
    }

    func loseCannonBall() {
        self.numCannonBallsRemaining -= 1
    }

    func gainCannonBall() {
        self.numCannonBallsRemaining += 1
    }

    func decreaseGameTime() {
        gameTimeLeft = max(gameTimeLeft - NumberConstants.gameInterval, 0.0)
    }

    func increaseGameTime() {
        gameTimeLeft += NumberConstants.gameInterval
    }

    func updateScore(pegsHitPerCannonBall: [Peg]) {
        var numBluePegs = 0
        var numOrangePegs = 0
        var numGreenPegs = 0

        for peg in pegsHitPerCannonBall {
            switch peg.color {
            case .blue: numBluePegs += 1
            case .orange: numOrangePegs += 1
            case .green: numGreenPegs += 1
            }
        }

        let totalNumPegs = numBluePegs + numOrangePegs + numGreenPegs

        let bluePegsScore = numBluePegs * NumberConstants.bluePegBaseScore
        let orangePegsScore = numOrangePegs * NumberConstants.orangePegBaseScore
        let greenPegsScore = numGreenPegs * NumberConstants.greenPegBaseScore

        self.score += totalNumPegs * (bluePegsScore + orangePegsScore + greenPegsScore)
    }

    func checkWinGame() -> Bool {
        return self.numOrangePegsRemaining == 0
    }

    func checkLoseGame() -> Bool {
        return (self.numCannonBallsRemaining == 0 && self.numOrangePegsRemaining > 0) ||
            (self.gameTimeLeft == 0.0 && self.numOrangePegsRemaining > 0)
    }

    func getNumOrangePegsRemaining() -> Int {
        return numOrangePegsRemaining
    }

    func getNumCannonBallsRemaining() -> Int {
        return numCannonBallsRemaining
    }

    func getGameTimeLeft() -> Float {
        return gameTimeLeft
    }

    func getScore() -> Int {
        return score
    }
}
