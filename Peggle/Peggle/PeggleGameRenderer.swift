//
//  PeggleGameRenderer.swift
//  Peggle
//
//  Created by Zhang Cheng on 8/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

class PeggleGameRenderer {
    private (set) var gameBoardView: UICollectionView
    private var physicsObjectUUIDToImageDict: [UUID: UIImageView]

    init(gameBoardView: UICollectionView) {
        self.gameBoardView = gameBoardView
        self.physicsObjectUUIDToImageDict = [:]
    }

    func addImage(physicsObject: PhysicsObject, image: UIImageView) {
        self.physicsObjectUUIDToImageDict[physicsObject.uuid] = image
        gameBoardView.addSubview(image)
    }

    func moveImages(physicsObjects: [PhysicsObject]) {
        for physicsObject in physicsObjects {
            guard let image = physicsObjectUUIDToImageDict[physicsObject.uuid] else {
                continue
            }

            image.center = CGPoint(x: physicsObject.x, y: physicsObject.y)
        }
    }

    func changeImage(physicsObject: PhysicsObject, image: UIImageView) {
        guard let originalImage = physicsObjectUUIDToImageDict[physicsObject.uuid] else {
            return
        }
        originalImage.removeFromSuperview()

        physicsObjectUUIDToImageDict[physicsObject.uuid] = image
        gameBoardView.addSubview(image)
    }

    func removeImage(physicsObject: PhysicsObject) {
        guard let image = physicsObjectUUIDToImageDict[physicsObject.uuid] else {
            return
        }

        physicsObjectUUIDToImageDict[physicsObject.uuid] = nil

        self.removeImageAnimation(image: image)
    }

    private func removeImageAnimation(image: UIImageView) {
        // Apply animation of fading out to pegs that are removed
        if let pegGlowView = image as? PegGlowView {
            UIView.animate(withDuration: 1, delay: 0.5, options: .curveEaseOut, animations: {
                    pegGlowView.alpha = 0.0
            }, completion: {
                (_: Bool) -> Void in
                image.removeFromSuperview()
            })
        } else {
            image.removeFromSuperview()
        }
    }
}
