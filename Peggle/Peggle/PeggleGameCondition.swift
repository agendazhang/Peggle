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

    init(pegBoardModel: PegBoardModel) {
        self.numCannonBallsRemaining = NumberConstants.defaultNumberOfCannonBalls

        var numOrangePegs = 0
        for peg in pegBoardModel.pegBoard.pegs where peg.color == .orange {
            numOrangePegs += 1
        }
        self.numOrangePegsRemaining = numOrangePegs
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

    func checkWinGame() -> Bool {
        return self.numOrangePegsRemaining == 0
    }

    func checkLoseGame() -> Bool {
        return self.numCannonBallsRemaining == 0 && self.numOrangePegsRemaining > 0
    }

    func getNumOrangePegsRemaining() -> Int {
        return numOrangePegsRemaining
    }

    func getNumCannonBallsRemaining() -> Int {
        return numCannonBallsRemaining
    }
}
