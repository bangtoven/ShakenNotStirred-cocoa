//
//  BartenderNameViewController.swift
//  VodkaMartini
//
//  Created by 방정호 on 2016. 12. 19..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Cocoa

class BartenderNameViewController: NSViewController {

    @IBOutlet weak var nameTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        Order.current = Order()
        Order.current.bartenderName = nameTextField.stringValue.isEmpty ? "Bartender0" : nameTextField.stringValue
    }
    
}
