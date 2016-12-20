//
//  ViewController.swift
//  test
//
//  Created by 방정호 on 2016. 12. 10..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Cocoa

class MixingViewController: NSViewController, ArduinoInterfaceDelegate {
    
    @IBOutlet weak var glassView: GlassView!
    @IBOutlet weak var weightLabel: NSTextField!
    
    @IBOutlet weak var bottlesView: BottlesView!
    @IBOutlet weak var slider1: NSSlider!
    @IBOutlet weak var slider2: NSSlider!
    @IBOutlet weak var slider3: NSSlider!
    var sliders: [NSSlider]!
    
    @IBOutlet weak var timerLabel: NSTextField!
    var timer: Timer!
    var timeCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        sliders = [slider1, slider2, slider3]
        
        ArduinoInterface.sharedInstance.delegate = self
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (t) in
            self.timeCount += 1
            let seconds = self.timeCount % 60
            let minutes = (self.timeCount / 60) % 60
            self.timerLabel.stringValue = String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    var playMyMixing = true
    @IBAction func togglePlayMode(_ sender: NSButton) {
        playMyMixing = !playMyMixing
        if playMyMixing == false {
            for i in 0..<2 {
                let v = Order.currentOrder?.orderMix?[i]
                StemPlayer.shared?.setVolume(v!, forTrack: i)
            }
            sender.stringValue = "Back to my mix."
        } else {
            sender.stringValue = "Play the order again."
        }
    }

    var zeroWeight = 0
    @IBAction func calibrateAction(_ sender: NSButton) {
        self.zeroWeight = Int(ArduinoInterface.sharedInstance.weight)
        self.mixAmount = [0,0,0]
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        self.timer.invalidate()
        Order.currentOrder?.resultMix = mixAmount.map( { Float($0)/Float(THRESHOLD)} )
        Order.currentOrder?.totalTime = timeCount
    }
    
    var currentState = HolderState.All
    var startingWeight = 0
    var mixAmount = [0,0,0]
    let THRESHOLD = 500
    
    func arduinoInterface(ai: ArduinoInterface, newState: HolderState) {
        self.currentState = newState
        
        bottlesView.updateWith(state: newState)
    }
    
    func arduinoInterface(ai: ArduinoInterface, newWeight: Int) {
        let weight = newWeight - zeroWeight
        self.weightLabel.integerValue = weight
        
        switch currentState {
        case .All, .Error:
            break
        default:
            let index = Int(currentState.rawValue)
            var amount = mixAmount[index] + (weight - startingWeight)
            startingWeight = weight
            if amount > THRESHOLD {
                amount = THRESHOLD
            } else if amount < 0 {
                amount = 0
            }
            mixAmount[index] = amount
            break
        }
        
        let max = CGFloat(mixAmount.max()!)
        guard max != 0 else {
            self.glassView.color = .clear
            return
        }
        
        var total = 0
        mixAmount.forEach { total += $0 }
        let alpha = CGFloat(total) / CGFloat(THRESHOLD*3)
        
        let color = NSColor(red: CGFloat(mixAmount[0])/max,
                            green: CGFloat(mixAmount[1])/max,
                            blue: CGFloat(mixAmount[2])/max,
                            alpha: alpha)
        self.glassView.color = color
        
        self.glassView.fillRatio = alpha
        
        ai.sendColorToSerial(color: color)
        
        if playMyMixing {
            for i in 0..<3 {
                let ratio = Float(mixAmount[i])/Float(THRESHOLD)
                StemPlayer.shared?.setVolume(ratio, forTrack: i)
                self.sliders[i].floatValue = ratio*100
            }
        }
    }
}

