//
//  TrianglePeg.swift
//  Peggle
//
//  Created by Zhang Cheng on 23/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

/**
`TrianglePeg` represents a triangular peg in the game.

Since we need to encode the triangular peg, it must conform to NSCoding and implement
the required functions.
*/
class TrianglePeg: NSObject, NSCoding, PhysicsTriangle {
    var uuid: UUID
    var x: CGFloat
    var y: CGFloat
    var color: PegColor
    var centerToVerticeDist: CGFloat
    var angle: CGFloat
    var canMove: Bool
    var velocity: CGVector

    init(x: CGFloat, y: CGFloat, color: PegColor, centerToVerticeDist: CGFloat, angle: CGFloat) {
        self.uuid = UUID()
        self.x = x
        self.y = y
        self.color = color
        self.centerToVerticeDist = centerToVerticeDist
        self.angle = angle
        self.canMove = false
        self.velocity = .zero
    }

    func getVerticesCoordinates() -> [CGPoint] {
        var coordinates = self.getOriginalVerticesCoordinates()

        let PI = CGFloat(Double.pi)

        for (index, coordinate) in coordinates.enumerated() {

            // Algorithm to find coordinates after rotation with angle:
            // 1. Subtract each coordinate with the value of the triangle center coordinates
            // 2. Multiple each coordinate by the rotation matrix
            //    ( cos(-angle)  -sin(-angle) )
            //    ( sin(-angle)  cos(-angle)  )
            // 3. Add back each coordinate with the value of the triangle center coordinates

            var newCoordinate = CGPoint(x: coordinate.x - self.x, y: coordinate.y -
                self.y)

            newCoordinate = CGPoint(x: newCoordinate.x * cos(PI * -angle / 180) +
                newCoordinate.y * sin(PI * -angle / 180), y: newCoordinate.x *
                -sin(PI * -angle / 180) + newCoordinate.y * cos(PI * -angle / 180))

            newCoordinate = CGPoint(x: newCoordinate.x + self.x, y: newCoordinate.y +
                self.y)

            coordinates[index] = newCoordinate
        }

        return coordinates
    }

    // This calculates the initial coordinates of the 3 vertices (one on top and two below)
    private func getOriginalVerticesCoordinates() -> [CGPoint] {
        var coordinates: [CGPoint] = []

        let PI = CGFloat(Double.pi)

        // Top vertice
        coordinates.append(CGPoint(x: self.x, y: self.y - self.centerToVerticeDist))
        // Bottom left vertice
        coordinates.append(CGPoint(x: self.x - self.centerToVerticeDist *
            sin(PI / 3), y: self.y + self.centerToVerticeDist * sin(PI / 6)))
        // Bottom right vertice
        coordinates.append(CGPoint(x: self.x + self.centerToVerticeDist *
            sin(PI / 3), y: self.y + self.centerToVerticeDist * sin(PI / 6)))

        return coordinates
    }

    // MARK: Equatable
    static func == (lhs: TrianglePeg, rhs: TrianglePeg) -> Bool {
        return lhs.x == rhs.x
            && lhs.y == rhs.y
            && lhs.color == rhs.color
            && lhs.centerToVerticeDist == rhs.centerToVerticeDist
            && lhs.angle == rhs.angle
    }

    // MARK: CustomStringConvertible
    override var description: String {
        return "\(self.color) Triangle Peg (\(self.x), \(self.y))"
    }

    // MARK: NSCoding
    required convenience init?(coder decoder: NSCoder) {
        guard let x = decoder.decodeObject(forKey: Keys.xKey.rawValue) as? CGFloat else {
            return nil
        }
        guard let y = decoder.decodeObject(forKey: Keys.yKey.rawValue) as? CGFloat else {
            return nil
        }
        guard let colorString = decoder.decodeObject(forKey: Keys.colorKey.rawValue) as? String, let color = PegColor(rawValue: colorString) else {
            return nil
        }
        guard let centerToVerticeDist = decoder.decodeObject(forKey:
            Keys.centerToVerticeDistKey.rawValue) as? CGFloat else {
            return nil
        }

        guard let angle = decoder.decodeObject(forKey: Keys.angleKey.rawValue) as? CGFloat else {
            return nil
        }

        self.init(x: x, y: y, color: color, centerToVerticeDist: centerToVerticeDist, angle:
            angle)
    }

    func encode(with encoder: NSCoder) {
        encoder.encode(self.x, forKey: Keys.xKey.rawValue)
        encoder.encode(self.y, forKey: Keys.yKey.rawValue)
        encoder.encode(self.color.rawValue, forKey: Keys.colorKey.rawValue)
        encoder.encode(self.centerToVerticeDist, forKey:
            Keys.centerToVerticeDistKey.rawValue)
        encoder.encode(self.angle, forKey: Keys.angleKey.rawValue)
    }
}
