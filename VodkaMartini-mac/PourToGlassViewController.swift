//
//  PourToGlassViewController.swift
//  VodkaMartini
//
//  Created by 방정호 on 2016. 12. 20..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Cocoa

class PourToGlassViewController: NSViewController, ArduinoInterfaceDelegate {

    @IBOutlet weak var instructionTextField: NSTextField!
    @IBOutlet weak var shakingLevelIndicator: NSLevelIndicator!
    @IBOutlet weak var nextButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var str = instructionTextField.stringValue
        if let b = Order.current.bartenderName {
            str = str.replacingOccurrences(of: "BARTENDER", with: b)
        }
        if let c = Order.current.customerName {
            str = str.replacingOccurrences(of: "CUSTOMER", with: c)
        }
        instructionTextField.stringValue = str

        nextButton.isEnabled = false
        ArduinoInterface.sharedInstance.delegate = self
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        StemPlayer.shared?.mute()
        ArduinoInterface.sharedInstance.delegate = nil
    }
    
    func arduinoInterface(ai: ArduinoInterface, newState: HolderState) {}
    func arduinoInterface(ai: ArduinoInterface, newWeight: Int) {}
    
    var shakingCount = 0
    func arduinoInterface(ai: ArduinoInterface, newShaking: Bool) {
        shakingCount += 1
        self.shakingLevelIndicator.integerValue = shakingCount
        if shakingCount >= 12 {
            nextButton.isEnabled = true
        }
    }
    
}
