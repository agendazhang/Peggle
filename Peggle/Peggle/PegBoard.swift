//
//  PegBoard.swift
//  Peggle
//
//  Created by Zhang Cheng on 24/1/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

/**
`PegBoard` represents the board where the pegs are on.
 
 Since we need to encode the peg board, it must conform to NSCoding and implement
 the required functions.
*/
class PegBoard: NSObject, NSCoding {
    private (set) var boardWidth: CGFloat
    private (set) var boardHeight: CGFloat
    private (set) var numRows: Int
    private (set) var numCols: Int
    private (set) var pegs: [Peg]

    init(boardWidth: CGFloat, boardHeight: CGFloat, pegs: [Peg]) {
        self.boardWidth = boardWidth
        self.boardHeight = boardHeight
        self.numRows = NumberConstants.numPegRows
        self.numCols = NumberConstants.numPegCols
        self.pegs = pegs
    }

    init(boardWidth: CGFloat, boardHeight: CGFloat) {
        self.boardWidth = boardWidth
        self.boardHeight = boardHeight
        self.numRows = NumberConstants.numPegRows
        self.numCols = NumberConstants.numPegCols
        self.pegs = []
    }

    override init() {
        self.boardWidth = NumberConstants.defaultBoardWidth
        self.boardHeight = NumberConstants.defaultBoardHeight
        self.numRows = NumberConstants.numPegRows
        self.numCols = NumberConstants.numPegCols
        self.pegs = []
    }

    private func calculateDefaultPegRadius() -> CGFloat {
        if boardWidth < boardHeight {
            return (boardWidth / 2) / CGFloat(numCols)
        } else {
            return (boardHeight / 2) / CGFloat(numRows)
        }
    }

    // Checks if a peg is more than a radius distance from all 4 borders
    // of the board
    private func isPegWithinBorder(peg: Peg) -> Bool {
        return peg.x >= peg.radius
            && peg.x < boardWidth - peg.radius
            && peg.y >= peg.radius
            && peg.y < boardHeight - peg.radius
    }

    // Checks if 2 pegs are more than a diameter distance apart
    private func arePegsWithinValidDistance(peg1: Peg,
        peg2: Peg) -> Bool {
        return sqrt(pow(peg1.x - peg2.x, 2.0)
            + pow(peg1.y - peg2.y, 2.0)) > peg1.radius + peg2.radius
    }

    // Checks if a point is within a radius distance from a peg
    private func isPointWithinPeg(point: CGPoint, peg: Peg) -> Bool {
        return sqrt(pow(point.x - peg.x, 2.0)
            + pow(point.y - peg.y, 2.0)) <= peg.radius
    }

    func getPegPosition(targetPeg: Peg) -> CGPoint {
        return CGPoint(x: targetPeg.x, y: targetPeg.y)
    }

    func getPeg(point: CGPoint) -> Peg? {
        for peg in pegs where isPointWithinPeg(point: point, peg: peg) {
            return peg
        }

        return nil
    }

    // Added peg's position must be more than a radius distance from all 4 borders
    // of the board and more than a diameter distance from all the current pegs
    // in the board
    func addPeg(position: CGPoint, color: PegColor) -> Bool {
        let newPeg = Peg(x: position.x, y: position.y, color: color, radius:
            calculateDefaultPegRadius())

        guard isPegWithinBorder(peg: newPeg) else {
            return false
        }

        for peg in pegs where !arePegsWithinValidDistance(peg1: newPeg,
            peg2: peg) {
            return false
        }

        pegs.append(newPeg)

        return true
    }

    // Position to remove a peg must be within a radius distance from one of
    // the pegs in the board
    func removePeg(position: CGPoint) -> Bool {
        guard let peg = getPeg(point: position) else {
            return false
        }

        return self.removePeg(targetPeg: peg)
    }

    private func removePeg(targetPeg: Peg) -> Bool {
        for i in 0..<pegs.count where pegs[i].x == targetPeg.x && pegs[i].y == targetPeg.y {
            pegs.remove(at: i)
            return true
        }

        return false
    }

    // oldPosition should be within a radius distance away from any peg in the board.
    // newPosition should be more than a radius distance away from all 4 borders and
    // more than a diameter distance away from all the other pegs in the board.
    func movePeg(oldPosition: CGPoint, newPosition: CGPoint) -> Bool {
        guard let oldPeg = getPeg(point: oldPosition) else {
            return false
        }

        let newPeg = Peg(x: newPosition.x, y: newPosition.y, color: oldPeg.color, radius:
            oldPeg.radius)

        // Moved peg must be within the 4 borders
        guard isPegWithinBorder(peg: newPeg) else {
            return false
        }

        // Moved peg must not overlap with any other pegs
        for peg in pegs where peg != oldPeg {
            if !arePegsWithinValidDistance(peg1: newPeg, peg2: peg) {
                return false
            }
        }

        oldPeg.x = newPosition.x
        oldPeg.y = newPosition.y

        return true
    }

    func resetPegBoard() -> Bool {
        pegs = []
        return true
    }

    func increasePegSize(position: CGPoint) -> Bool {
        guard let oldPeg = getPeg(point: position) else {
            return false
        }

        // Maximum peg radius is 2 times the default peg radius
        guard oldPeg.radius * NumberConstants.increaseSizeRatio <=
            calculateDefaultPegRadius() * NumberConstants.maximumSizeRatio else {
            return false
        }

        let newPeg = Peg(x: oldPeg.x, y: oldPeg.y, color: oldPeg.color, radius:
            oldPeg.radius * NumberConstants.increaseSizeRatio)

        // Resized peg must be within the 4 borders
        guard isPegWithinBorder(peg: newPeg) else {
            return false
        }

        // Resized peg must not overlap with any other pegs
        for peg in pegs where !arePegsWithinValidDistance(peg1: newPeg,
            peg2: peg) && (peg.x != oldPeg.x || peg.y != oldPeg.y) {
            return false
        }

        oldPeg.radius = oldPeg.radius * NumberConstants.increaseSizeRatio

        return true
    }

    func decreasePegSize(position: CGPoint) -> Bool {
        guard let oldPeg = getPeg(point: position) else {
            return false
        }

        // Minimum peg radius is 0.5 times the default peg radius
        guard oldPeg.radius * NumberConstants.decreaseSizeRatio >=
            calculateDefaultPegRadius() * NumberConstants.minimumSizeRatio else {
            return false
        }

        let newPeg = Peg(x: oldPeg.x, y: oldPeg.y, color: oldPeg.color, radius:
            oldPeg.radius * NumberConstants.decreaseSizeRatio)

        // Resized peg must be within the 4 borders
        guard isPegWithinBorder(peg: newPeg) else {
            return false
        }

        // Resized peg must not overlap with any other pegs
        for peg in pegs where !arePegsWithinValidDistance(peg1: newPeg,
            peg2: peg) && (peg.x != oldPeg.x || peg.y != oldPeg.y) {
            return false
        }

        oldPeg.radius = oldPeg.radius * NumberConstants.decreaseSizeRatio

        return true
    }

    func getNumPegs() -> [PegColor: Int] {
        var numPegs = [PegColor.blue: 0, PegColor.orange: 0, PegColor.green: 0]

        for peg in pegs {
            if peg.color == .blue {
                guard let bluePegCount = numPegs[.blue] else {
                    continue
                }
                numPegs[.blue] = bluePegCount + 1
            } else if peg.color == .orange {
                guard let orangePegCount = numPegs[.orange] else {
                    continue
                }
                numPegs[.orange] = orangePegCount + 1
            } else if peg.color == .green {
                guard let  greenPegCount = numPegs[.green] else {
                    continue
                }
                numPegs[.green] = greenPegCount + 1
            }
        }

        return numPegs
    }

    // MARK: CustomStringConvertible
    override var description: String {
        return "\(self.pegs)"
    }

    // MARK: NSCoding
    required convenience init?(coder decoder: NSCoder) {
        guard let boardWidth = decoder.decodeObject(forKey: Keys.boardWidthKey.rawValue) as?
            CGFloat else {
            return nil
        }

        guard let boardHeight = decoder.decodeObject(forKey: Keys.boardHeightKey.rawValue)
            as? CGFloat
            else {
            return nil
        }

        guard let pegs = decoder.decodeObject(forKey: Keys.pegsKey.rawValue) as? [Peg] else {
            return nil
        }

        self.init(boardWidth: boardWidth, boardHeight: boardHeight, pegs: pegs)
    }

    func encode(with encoder: NSCoder) {
        encoder.encode(self.boardWidth, forKey: Keys.boardWidthKey.rawValue)
        encoder.encode(self.boardHeight, forKey: Keys.boardHeightKey.rawValue)
        encoder.encode(self.pegs, forKey: Keys.pegsKey.rawValue)
    }
}
