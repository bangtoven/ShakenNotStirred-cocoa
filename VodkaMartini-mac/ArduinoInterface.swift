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
    
    override init() {
        super.init()
        
        setbuf(stdout, nil)
        
        self.serialPort = ORSSerialPort(path: "/dev/cu.usbmodem1421")
        self.serialPort?.baudRate = 9600
        self.serialPort?.delegate = self
        
        serialPort?.open()
        
        // [strt , (data) , fnsh]: arduino uses this protocol.
        let desc = ORSSerialPacketDescriptor(prefixString: "strt", suffixString: "fnsh", maximumPacketLength: 20, userInfo: nil)
        serialPort?.startListeningForPackets(matching: desc)
    }
    
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
