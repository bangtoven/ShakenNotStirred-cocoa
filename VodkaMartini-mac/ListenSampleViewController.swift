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
    }
    
    func arduinoInterface(ai: ArduinoInterface, newWeight: Int) {
    }
    
}
