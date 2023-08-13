//
//  SoundManager.swift
//  RainCat
//
//  Created by Roman Lantsov on 13.08.2023.
//

import AVFoundation

class SoundManager: NSObject, AVAudioPlayerDelegate {
    static let shared = SoundManager()
    
    var audioPlayer: AVAudioPlayer?
    var trackPosition = 0
    
    //Music: https://www.bensound.com/royalty-free-music
    static let tracks = [
        "bensound-clearday",
        "bensound-jazzcomedy",
        "bensound-jazzyfrenchy",
        "bensound-littleidea"
    ]
    
    //This is private, so you can have only one Sound Manager ever.
    private override init() {
        trackPosition = Int(arc4random_uniform(UInt32(SoundManager.tracks.count)))
    }
    
    public func startPlaying() {
        if audioPlayer == nil || audioPlayer?.isPlaying == false {
            let soundURL = Bundle.main.url(
                forResource: SoundManager.tracks[trackPosition],
                withExtension: "mp3"
            )
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
                audioPlayer?.delegate = self
            } catch {
                print("audio player failed to load")
                startPlaying()
            }
            
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            
            trackPosition = (trackPosition + 1) % SoundManager.tracks.count
        } else {
            print("Audio player is already playing!")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //Just play the next track.
        startPlaying()
    }
}
