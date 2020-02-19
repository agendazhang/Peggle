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

    private func calculatePegRadius() -> CGFloat {
        if boardWidth < boardHeight {
            return (boardWidth / 2) / CGFloat(numCols)
        } else {
            return (boardHeight / 2) / CGFloat(numRows)
        }
    }

    // Checks if a point is more than a radius distance from all 4 borders
    // of the board
    private func isPegWithinBorder(pegPosition: CGPoint) -> Bool {
        let pegRadius = calculatePegRadius()
        return pegPosition.x >= pegRadius
            && pegPosition.x < boardWidth - pegRadius
            && pegPosition.y >= pegRadius
            && pegPosition.y < boardHeight - pegRadius
    }

    // Checks if 2 points are more than a diameter distance apart
    private func arePegsWithinValidDistance(peg1Position: CGPoint,
        peg2Position: CGPoint) -> Bool {
        return sqrt(pow(peg1Position.x - peg2Position.x, 2.0)
            + pow(peg1Position.y - peg2Position.y, 2.0)) > calculatePegRadius() * 2
    }

    // Checks if a point is within a radius distance from a peg
    private func isPointWithinPeg(point: CGPoint, pegPosition: CGPoint) -> Bool {
        let pegRadius = calculatePegRadius()
        return sqrt(pow(point.x - pegPosition.x, 2.0)
            + pow(point.y - pegPosition.y, 2.0)) <= pegRadius
    }

    func getPegPosition(targetPeg: Peg) -> CGPoint {
        return CGPoint(x: targetPeg.x, y: targetPeg.y)
    }

    func getPeg(point: CGPoint) -> Peg? {
        for peg in pegs where isPointWithinPeg(point: point, pegPosition:
            getPegPosition(targetPeg: peg)) {

            return peg
        }

        return nil
    }

    // Added peg's position must be more than a radius distance from all 4 borders
    // of the board and more than a diameter distance from all the current pegs
    // in the board
    func addPeg(position: CGPoint, color: PegColor) -> Bool {
        guard isPegWithinBorder(pegPosition: position) else {
            return false
        }

        for peg in pegs where !arePegsWithinValidDistance(peg1Position: position,
            peg2Position: getPegPosition(targetPeg: peg)) {
            return false
        }

        let newPeg = Peg(x: position.x, y: position.y, color: color, radius:
            calculatePegRadius())
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
        for i in 0..<pegs.count where pegs[i] == targetPeg {
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

        guard isPegWithinBorder(pegPosition: newPosition) else {
            return false
        }

        for peg in pegs where peg != oldPeg {
            if !arePegsWithinValidDistance(peg1Position: newPosition,
                peg2Position: getPegPosition(targetPeg: peg)) {
                return false
            }
        }

        return self.addPeg(position: newPosition, color: oldPeg.color)
            && self.removePeg(targetPeg: oldPeg)
    }

    func resetPegBoard() -> Bool {
        pegs = []
        return true
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
