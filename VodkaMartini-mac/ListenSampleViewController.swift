//
//  ListenSampleViewController.swift
//  VodkaMartini
//
//  Created by 방정호 on 2016. 12. 20..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Cocoa

class ListenSampleViewController: NSViewController, ArduinoInterfaceDelegate {

    @IBOutlet weak var bottlesView: BottlesView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ArduinoInterface.sharedInstance.delegate = self
    }
    
    func arduinoInterface(ai: ArduinoInterface, newState: HolderState) {
        bottlesView.updateWith(state: newState)
    
        if let player = StemPlayer.shared {
            switch newState {
            case .All, .Error:
                player.mute()
                player.stop()
            default:
                let index = Int(newState.rawValue)
                player.setVolume(1.0, forTrack: index)
                player.play()
                break
            }
        }
    }
    
    func arduinoInterface(ai: ArduinoInterface, newWeight: Int) {}
    func arduinoInterface(ai: ArduinoInterface, newShaking: Bool) {}
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        ArduinoInterface.sharedInstance.delegate = nil
        StemPlayer.shared?.stop()
    }
    
}
