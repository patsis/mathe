//
//  PlaySound.swift
//  mathe
//
//  Created by Harry Patsis on 10/5/20.
//  Copyright © 2020 patsis. All rights reserved.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(name: String, type :String) {
	if let path = Bundle.main.path(forResource: name, ofType: type) {
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
			audioPlayer?.play()
		} catch {
			print("Error playing audio")
		}
	}
}
