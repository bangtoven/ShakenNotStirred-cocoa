//
//  ScoreViewController.swift
//  VodkaMartini
//
//  Created by 방정호 on 2016. 12. 20..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Cocoa
import AVFoundation

class ScoreViewController: NSViewController {

    @IBOutlet weak var namesLabel: NSTextField!
    @IBOutlet weak var scoreLabel: NSTextField!
    var player: AVPlayer!
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let r = Order()
        r.bartenderName = "Sexy하게"
        r.customerName = "qkdwjdgh!"
        r.orderMix = [1, 0.9, 0.2]
        r.resultMix = [0.9, 0.3, 0.5]
        r.totalTime = 100
        Order.current = r
        
        var str = namesLabel.stringValue
        if let b = Order.current.bartenderName {
            str = str.replacingOccurrences(of: "BARTENDER", with: b)
        }
        if let c = Order.current.customerName {
            str = str.replacingOccurrences(of: "CUSTOMER", with: c)
        }
        namesLabel.stringValue = str
        
        player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forSoundResource: "score.m4a")!))
        player.play()
        
        scoreLabel.stringValue = ""
        self.showScore()
        
        Timer.scheduledTimer(withTimeInterval: 1.6, repeats: true) { (t) in
            self.count += 1
            self.showScore()
            if self.count == 6 {
                t.invalidate()
            }
        }
    }
    
    var totalScore = 0
    
    func showScore() {
        var appending: String
        switch self.count {
        case 0...2:
            let s = score(a: Order.current.orderMix[self.count], b: Order.current.resultMix[self.count])
            appending = "\(s)"
            totalScore += s
        case 3:
            var s = -0.075*Double(Order.current.totalTime) + 15
            if s > 10{
                s = 10
            } else if s < 0 {
                s = 0
            }
            appending = "\(s)"
            totalScore += Int(s.rounded())
        case 5:
            appending = "\(self.totalScore)"
        default:
            appending = " "
        }
        scoreLabel.stringValue = scoreLabel.stringValue.appending("\(appending)\n")
    }
    
    func score(a: Float, b: Float) -> Int {
        let abs = Float.abs(a-b)
        let score = 35 - 35*abs
        if score > 30 {
            return 30
        } else {
            return Int(score.rounded())
        }
    }
    
}
