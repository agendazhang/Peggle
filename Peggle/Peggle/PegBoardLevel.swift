//
//  PegBoardLevel.swift
//  Peggle
//
//  Created by Zhang Cheng on 24/1/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

/**
`PegBoardLevel` represents a level in the `Peggle` game.
*/
class PegBoardLevel: NSObject {
    private (set) var pegBoard: PegBoard
    var levelName: String?

    override init() {
        self.pegBoard = PegBoard()
        self.levelName = nil
    }

    init(boardWidth: CGFloat, boardHeight: CGFloat) {
        self.pegBoard = PegBoard(boardWidth: boardWidth, boardHeight: boardHeight)
        self.levelName = nil
    }

    init(boardWidth: CGFloat, boardHeight: CGFloat, levelName: String) {
        self.pegBoard = PegBoard(boardWidth: boardWidth, boardHeight: boardHeight)
        self.levelName = levelName
    }

    init(pegBoard: PegBoard, levelName: String) {
        self.pegBoard = pegBoard
        self.levelName = levelName
    }

    func getPegs() -> [Peg] {
        return pegBoard.pegs
    }

    func getPegPosition(targetPeg: Peg) -> CGPoint {
        return pegBoard.getPegPosition(targetPeg: targetPeg)
    }

    func getPeg(point: CGPoint) -> Peg? {
        return pegBoard.getPeg(point: point)
    }

    func addPeg(position: CGPoint, color: PegColor) -> Bool {
        return pegBoard.addPeg(position: position, color: color)
    }

    func removePeg(position: CGPoint) -> Bool {
        return pegBoard.removePeg(position: position)
    }

    func movePeg(oldPosition: CGPoint, newPosition: CGPoint) -> Bool {
        return pegBoard.movePeg(oldPosition: oldPosition, newPosition: newPosition)
    }

    func resetPegBoard() -> Bool {
        return pegBoard.resetPegBoard()
    }

    func printPegBoard() -> String {
        return "\(self.pegBoard)"
    }
}
