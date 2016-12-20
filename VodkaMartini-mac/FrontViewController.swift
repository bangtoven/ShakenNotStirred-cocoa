//
//  FrontViewController.swift
//  VodkaMartini
//
//  Created by 방정호 on 2016. 12. 20..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Cocoa

class FrontViewController: NSViewController {

    @IBOutlet weak var scoreLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let order = Order.current {
            scoreLabel.stringValue = "Last score by \(order.bartenderName!): \(order.score!)"
        } else {
            scoreLabel.stringValue = ""
        }
    }
    
}
