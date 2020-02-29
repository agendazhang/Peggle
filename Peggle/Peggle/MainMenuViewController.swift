//
//  MainMenuViewController.swift
//  Peggle
//
//  Created by Zhang Cheng on 7/2/20.
//  Copyright © 2020 Zhang Cheng. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    private var musicPlayer = MusicPlayer()

    override func viewDidLoad() {

    }

    override func viewDidAppear(_ animated: Bool) {
        musicPlayer.playBackgroundMusic(fileName:
            StringConstants.mainMenuBackgroundMusicPath)
    }

    override func viewDidDisappear(_ animated: Bool) {
        musicPlayer.stopMusicPlayer()
    }
}
