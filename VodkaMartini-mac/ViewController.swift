//
//  ViewController.swift
//  test
//
//  Created by 방정호 on 2016. 12. 10..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Cocoa
//import AudioKit


class ViewController: NSViewController, ArduinoInterfaceDelegate {
    
    @IBOutlet weak var label: NSTextField!
    @IBOutlet weak var slider0: NSSlider!
    @IBOutlet weak var slider1: NSSlider!
    @IBOutlet weak var slider2: NSSlider!
    @IBOutlet weak var slider3: NSSlider!
    var sliders: [NSSlider]!
    
    var player: StemPlayer?
    @IBOutlet weak var glassView: GlassView!
    
    @IBOutlet weak var bottlesView: BottlesView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ArduinoInterface.sharedInstance.runProcessingInput()
        ArduinoInterface.sharedInstance.delegate = self
        
        sliders = [slider0, slider1, slider2, slider3]
        
        let url = Bundle.main.url(forResource: "master.stem", withExtension: "mp4")!
        player = StemPlayer(url: url)
        player?.play()
        
        
//        
        
        
        
//        let crom = NSSound(named: "crom.mp3")
//        let bang = NSSound(named: "bang.mp3")
//        crom!.playbackDeviceIdentifier = "AppleHDAEngineOutput:1B,0,1,1:0"
//        bang!.playbackDeviceIdentifier = "AppleHDAEngineOutputDP:3,0,1,0:0:{6D1E-5A2B-01010101}"
//        crom?.play()
//        bang?.play()
        
//        let devices = AMAudioDevice.allDevices()
//        devices.forEach { (d) in
//            print(d.deviceUID())
//        }

//        AudioKit.availableOutputs?.forEach({ (d) in
//            print(d)
//        })
        
        bottlesView.updateWith(state: .Bottle1)
    }

    var zeroWeight = 0
    @IBAction func calibrateAction(_ sender: Any) {
        self.zeroWeight = Int(ArduinoInterface.sharedInstance.weight)
        self.mixAmount = [0,0,0]
    }
    
    var currentState = HolderState.All
    var startingWeight = 0
    var mixAmount = [0,0,0]
    let THRESHOLD = 500
    
    func arduinoInterface(ai: ArduinoInterface, newState: HolderState) {
        self.currentState = newState
    }
    
    func arduinoInterface(ai: ArduinoInterface, newWeight: Int) {
        let weight = newWeight - zeroWeight
        self.label.integerValue = weight
        
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
        
//        var color = NSColor.clear
//        var total:CGFloat = 100.0
//        total += CGFloat(mixAmount[0])
//        color = color.blended(withFraction: CGFloat(mixAmount[0])/total, of: NSColor.red)!
//
//        total += CGFloat(mixAmount[1])
//        color = color.blended(withFraction: CGFloat(mixAmount[1])/total, of: NSColor.green)!
//        
//        total += CGFloat(mixAmount[2])
//        color = color.blended(withFraction: CGFloat(mixAmount[2])/total, of: NSColor.blue)!
        
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
        
        for i in 0..<3 {
            let ratio = Float(mixAmount[i])/Float(THRESHOLD)
            self.player?.setVolume(ratio, forTrack: i)
            self.sliders[i].floatValue = ratio*100
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: NSSlider) {
        let volume = sender.floatValue/100.0
        print(volume)
        
        self.player?.setVolume(volume, forTrack: sender.tag)

        self.glassView.color = NSColor(calibratedHue: CGFloat(volume), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        
        self.glassView.fillRatio = CGFloat(volume)
        
        
        bottlesView.updateWith(state: HolderState(rawValue: Int16(sender.tag))!)
        
//        if let wc = self.view.window?.windowController as? WindowController {
//            wc.afafafaf()
//        }
    }
    
    @IBAction func checkValueChanged(_ sender: NSButton) {
        
//        switch sender.state {
//        case NSOnState:
//            self.player?.currentItem?.tracks[0].isEnabled = true
//            self.player?.currentItem?.tracks[1].isEnabled = false
//        default:
//            self.player?.currentItem?.tracks[0].isEnabled = false
//            self.player?.currentItem?.tracks[1].isEnabled = true
//        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
//    func handle(_ errorCode: OSStatus) throws {
//        if errorCode != kAudioHardwareNoError {
//            let error = NSError(domain: NSOSStatusErrorDomain, code: Int(errorCode), userInfo: [NSLocalizedDescriptionKey : "CAError: \(errorCode)" ])
//            NSApplication.shared().presentError(error)
//            throw error
//        }
//    }
//    
//    func getInputDevices() throws -> [AudioDeviceID] {
//        
//        var inputDevices: [AudioDeviceID] = []
//        
//        // Construct the address of the property which holds all available devices
//        var devicesPropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioHardwarePropertyDevices, mScope: kAudioObjectPropertyScopeGlobal, mElement: kAudioObjectPropertyElementMaster)
//        var propertySize = UInt32(0)
//        
//        // Get the size of the property in the kAudioObjectSystemObject so we can make space to store it
//        try handle(AudioObjectGetPropertyDataSize(AudioObjectID(kAudioObjectSystemObject), &devicesPropertyAddress, 0, nil, &propertySize))
//        
//        // Get the number of devices by dividing the property address by the size of AudioDeviceIDs
//        let numberOfDevices = Int(propertySize) / MemoryLayout<AudioDeviceID>.size
//        
//        // Create space to store the values
//        var deviceIDs: [AudioDeviceID] = []
//        for _ in 0 ..< numberOfDevices {
//            deviceIDs.append(AudioDeviceID())
//        }
//        
//        // Get the available devices
//        try handle(AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &devicesPropertyAddress, 0, nil, &propertySize, &deviceIDs))
//        
//        // Iterate
//        for id in deviceIDs {
//            
//            // Get the device name for fun
//            var name: CFString = "" as CFString
//            var propertySize = UInt32(MemoryLayout<CFString>.size)
//            var deviceNamePropertyAddress = AudioObjectPropertyAddress(mSelector: kAudioDevicePropertyDeviceNameCFString, mScope: kAudioObjectPropertyScopeGlobal, mElement: kAudioObjectPropertyElementMaster)
//            try handle(AudioObjectGetPropertyData(id, &deviceNamePropertyAddress, 0, nil, &propertySize, &name))
//            
//            // Check the input scope of the device for any channels. That would mean it's an input device
//            
//            // Get the stream configuration of the device. It's a list of audio buffers.
//            var streamConfigAddress = AudioObjectPropertyAddress(mSelector: kAudioDevicePropertyStreamConfiguration, mScope: kAudioDevicePropertyScopeInput, mElement: 0)
//            
//            // Get the size so we can make room again
//            try handle(AudioObjectGetPropertyDataSize(id, &streamConfigAddress, 0, nil, &propertySize))
//            
//            // Create a buffer list with the property size we just got and let core audio fill it
//            let audioBufferList = AudioBufferList.allocate(maximumBuffers: Int(propertySize))
//            try handle(AudioObjectGetPropertyData(id, &streamConfigAddress, 0, nil, &propertySize, audioBufferList.unsafeMutablePointer))
//            
//            // Get the number of channels in all the audio buffers in the audio buffer list
//            var channelCount = 0
//            for i in 0 ..< Int(audioBufferList.unsafeMutablePointer.pointee.mNumberBuffers) {
//                channelCount = channelCount + Int(audioBufferList[i].mNumberChannels)
//            }
//            
//            free(audioBufferList.unsafeMutablePointer)
//            
//            // If there are channels, it's an input device
//            if channelCount > 0 {
//                Swift.print("Found input device '\(name)' with \(channelCount) channels")
//                inputDevices.append(id)
//            } else {
//                print("\(name)")
//            }
//        }
//        
//        return inputDevices
//    }
    
}

