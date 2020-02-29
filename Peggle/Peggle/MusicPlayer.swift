//
//  MusicPlayer.swift
//  Peggle
//
//  Created by Zhang Cheng on 29/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import Foundation
import AVFoundation

// All the music and sounds are from the open source website freesound.org
class MusicPlayer {

    var musicAudioPlayer: AVAudioPlayer?
    var soundAudioPlayer: AVAudioPlayer?

    func playBackgroundMusic(fileName: String) {
        if let bundle = Bundle.main.path(forResource: fileName, ofType: "mp3") {
            let backgroundMusicURL = NSURL(fileURLWithPath: bundle)
            do {
                musicAudioPlayer = try AVAudioPlayer(contentsOf: backgroundMusicURL as URL)
                guard let musicAudioPlayer = musicAudioPlayer else {
                    return
                }

                // Set it to -1 to keep looping
                musicAudioPlayer.numberOfLoops = -1
                musicAudioPlayer.prepareToPlay()
                musicAudioPlayer.play()
            } catch {
                print(error)
            }
        }
    }

    func playSoundEffect(fileName: String) {
        if let bundle = Bundle.main.path(forResource: fileName, ofType: "wav") {
            let soundEffectURL = NSURL(fileURLWithPath: bundle)
            do {
                soundAudioPlayer = try AVAudioPlayer(contentsOf: soundEffectURL as URL)
                guard let soundAudioPlayer = soundAudioPlayer else {
                    return
                }

                // Play only once
                soundAudioPlayer.play()
            } catch {
                print(error)
            }
        }
    }

    func pauseMusicPlayer() {
        musicAudioPlayer?.pause()
    }

    func stopMusicPlayer() {
        musicAudioPlayer?.stop()
    }
}
