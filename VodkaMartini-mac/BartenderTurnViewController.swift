//
//  BartenderTurnViewController.swift
//  VodkaMartini
//
//  Created by 방정호 on 2016. 12. 20..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Cocoa

class BartenderTurnViewController: NSViewController {

    @IBOutlet weak var instructionTextField: NSTextField!
    
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
    }
    
}
