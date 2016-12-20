//
//  WhichJBViewController.swift
//  VodkaMartini
//
//  Created by 방정호 on 2016. 12. 19..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Cocoa

class WhichJBViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func buttonAction(_ sender: NSButton) {
        let names = ["James Bond", "Jack Bauer", "Jason Bourne", "Jungho Bang"]
        Order.currentOrder?.customerName = names[sender.tag]
        self.performSegue(withIdentifier: "replace", sender: nil)
    }
    
}
