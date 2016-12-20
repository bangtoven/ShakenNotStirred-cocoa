//
//  FinishOrderViewController.swift
//  VodkaMartini
//
//  Created by 방정호 on 2016. 12. 20..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Cocoa

class FinishOrderViewController: NSViewController, SliderAppInterfaceDelegate {

    @IBOutlet weak var progress0: NSProgressIndicator!
    @IBOutlet weak var progress1: NSProgressIndicator!
    @IBOutlet weak var progress2: NSProgressIndicator!
    var progressBars: [NSProgressIndicator]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SliderAppInterface().delegate = self
        
        progressBars = [progress0, progress1, progress2]
    }
    
    func sliderAppUpdate(index: Int, value: Float) {
        progressBars[index].doubleValue = Double(value)
    }
    
}
