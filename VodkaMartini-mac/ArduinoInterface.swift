//
//  ArduinoInterface.swift
//  game2
//
//  Created by 방정호 on 2016. 11. 8..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Cocoa
import ORSSerial

protocol ArduinoInterfaceDelegate {
    func arduinoInterface(ai: ArduinoInterface, newState: HolderState)
    func arduinoInterface(ai: ArduinoInterface, newWeight: Int)
}

enum HolderState: Int16 {
    case All = -1
    case Bottle0 = 0
    case Bottle1 = 1
    case Bottle2 = 2
    case Error = 3
}

class ArduinoInterface: NSObject, ORSSerialPortDelegate {
    var serialPort: ORSSerialPort?
    var delegate: ArduinoInterfaceDelegate?
    
    static let sharedInstance = ArduinoInterface()
    
    func runProcessingInput() {
        setbuf(stdout, nil)
        
        self.serialPort = ORSSerialPort(path: "/dev/cu.usbmodem1411")
        self.serialPort?.baudRate = 9600
        self.serialPort?.delegate = self
        
        serialPort?.open()
        
        // [strt , (data) , fnsh]: arduino uses this protocol.
        let desc = ORSSerialPacketDescriptor(prefixString: "strt", suffixString: "fnsh", maximumPacketLength: 20, userInfo: nil)
        serialPort?.startListeningForPackets(matching: desc)
    }
    
    // false = READY, true = PLAYING
//    var gameState = false
//    
//    var lastRoll : Float = -1.0
//    var swingCount = 0
//    var message = ""
    
    var holderState: HolderState = .Error
    var weight: Int16 = 0
    
    func serialPort(_ serialPort: ORSSerialPort, didReceivePacket packetData: Data, matching descriptor:ORSSerialPacketDescriptor) {
        let data = packetData.withUnsafeBytes {
            Array(UnsafeBufferPointer<Int16>(start: $0.advanced(by: 2), count: 2))
        }
        
        if let holderState = HolderState(rawValue: data[0]), holderState != self.holderState {
            self.holderState = holderState
            self.delegate?.arduinoInterface(ai: self, newState: holderState)
        }
        
        let weight = data[1]
        self.weight = weight
        self.delegate?.arduinoInterface(ai: self, newWeight: Int(weight))
        
//        switch holderState {
//        case .All, .Error:
//            break
//        default:
//            let index = Int(holderState.rawValue)
//            var out:[UInt8] = [0, 0, 0]
//            out[index] = UInt8(weight/12)
//            sendDataToSerial(data: out)
//        }
//        
        
//        delegate?.arduinoInterface(ai: self, newAccel: accel)
//        
//        let currRoll = data[11]
//        if accel > 2 && lastRoll > 0 && currRoll < 0 { // detect zero-crossing
//            swingCount += 1
//            delegate?.arduinoInterface(ai: self, newSwingCount: swingCount)
//        }
//        lastRoll = currRoll
        
        
//        // Send back data to Arduino
//        var state: [UInt8] = [gameState ? 1 : 0]
//        sendDataToSerial(data: &state)
//        
//        var led: [UInt8] = (accel > 4) ? [1,0] : [0, 1] // Turn red or green
//        sendDataToSerial(data: &led)
//        
//        var frequency: [UInt8]
//        if accel > -16.0 || accel < 16.0 { // in normal range
//            let freq = (UInt16)(400.0 + 30.0*accel) // frequency according to the accel
//            frequency = [(UInt8)(freq >> 8),
//                         (UInt8)(freq % 256)]
//        } else {
//            frequency = [0,0]
//        }
//        sendDataToSerial(data: &frequency)
//        
//        if let str = self.message.appending(".").data(using: String.Encoding.ascii) {
//            self.serialPort?.send(str)
//        }
    }
    
    func sendColorToSerial(color: NSColor) {
        var out:[UInt8] = [0, 0, 0]
        out[0] = UInt8(color.redComponent*255)
        out[1] = UInt8(color.greenComponent*255)
        out[2] = UInt8(color.blueComponent*255)
        sendDataToSerial(data: out)
    }
    
    func sendDataToSerial(data: [UInt8]) {
        var asInOut = data
        let out = Data(buffer: UnsafeBufferPointer(start: &asInOut, count: data.count))
        self.serialPort?.send(out)
    }
    
    
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        print("Serial port \(serialPort) was opened")
    }
    
    func serialPortWasRemoved(fromSystem serialPort: ORSSerialPort) {
        self.serialPort = nil
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        print("Serial port (\(serialPort)) encountered error: \(error)")
    }
}
