//
//  MixerCalibrateViewController.swift
//  VodkaMartini
//
//  Created by 방정호 on 2016. 12. 20..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Cocoa

class CalibrateViewController: NSViewController, ArduinoInterfaceDelegate {

    @IBOutlet weak var glassView: GlassView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ArduinoInterface.sharedInstance.delegate = self
    }
    
    func arduinoInterface(ai: ArduinoInterface, newState: HolderState) {
    }
    
    func arduinoInterface(ai: ArduinoInterface, newWeight: Int) {
        var weight = CGFloat(newWeight)
        weight -= 100
        if weight < 0 {
            weight = 50
        }
        glassView.alphaValue = weight / 500
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        ArduinoInterface.sharedInstance.delegate = nil
        (segue.destinationController as! MixingViewController).zeroWeight = Int(ArduinoInterface.sharedInstance.weight)
    }
    
}
