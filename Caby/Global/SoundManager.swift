//
//  SoundManager.swift
//  CueRide
//
//  Created by Vivek on 27/1/2017.
//  Copyright © 2017 hyperlink. All rights reserved.
//

import Foundation
import AVFoundation

extension SoundManager {
    func playSound (numberOfLoops : Int = 0) {
        audioPlayer.numberOfLoops = numberOfLoops
        audioPlayer.play()
    }
}

class SoundManager {
    
    static let shared : SoundManager = SoundManager()
    
    var fileName : String = "onArrive"
    var extentionName : String = "wav"
    
    var CatSound : NSURL?
    var audioPlayer = AVAudioPlayer()
    
    init () {
        CatSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: fileName, ofType: extentionName)!)
        do {
            if CatSound != nil {
                audioPlayer = try AVAudioPlayer(contentsOf: CatSound! as URL)
                audioPlayer.prepareToPlay()
            }
        } catch {
            debugPrint("Problem in getting File")
        }
    }
}
