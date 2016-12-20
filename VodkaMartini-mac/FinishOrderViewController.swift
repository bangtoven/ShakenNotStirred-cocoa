//
//  FinishOrderViewController.swift
//  VodkaMartini
//
//  Created by 방정호 on 2016. 12. 20..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Cocoa

class FinishOrderViewController: NSViewController, SliderAppInterfaceDelegate {

    @IBOutlet weak var slider0: NSSlider!
    @IBOutlet weak var slider1: NSSlider!
    @IBOutlet weak var slider2: NSSlider!
    var sliders: [NSSlider]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sliders = [slider0, slider1, slider2]
        
        SliderAppInterface.sharedInstance.delegate = self
        
        StemPlayer.shared?.play()
    }
    
    @IBAction func sliderValueChanged(_ sender: NSSlider) {
        let volume = sender.floatValue/100.0
        
        StemPlayer.shared?.setVolume(volume, forTrack: sender.tag)
    }
    
    func sliderAppUpdate(index: Int, value: Float) {
        sliders[index].floatValue = value*100
        StemPlayer.shared?.setVolume(value, forTrack: index)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        Order.currentOrder?.orderMix = sliders.map({ $0.floatValue })
        SliderAppInterface.sharedInstance.delegate = nil
    }
    
}
