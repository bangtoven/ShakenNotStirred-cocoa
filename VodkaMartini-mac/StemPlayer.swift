//
//  StemPlayer.swift
//  test
//
//  Created by 방정호 on 2016. 12. 19..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Cocoa
import AVFoundation

class StemPlayer {
    
    static private var sharedInstance: StemPlayer?
    static var shared: StemPlayer? {
        if sharedInstance != nil {
            return sharedInstance
        } else if let url = Order.currentOrder?.stemFilePath {
            return StemPlayer(url: url)
        } else {
            return nil
        }
    }
    
    var players = [AVQueuePlayer]()
    var loopers = [AVPlayerLooper]()
    
    var stemData: [[String:String]]?
    
    init(url: URL) {
        let asset = AVAsset(url: url)
        for metaItem in asset.metadata {
            if metaItem.identifier == "uiso/stem" {
                do {
                    let json = try JSONSerialization.jsonObject(with: metaItem.value as! Data, options: .allowFragments) as! [String:Any]
                    self.stemData = json["stems"] as? [[String:String]]
                } catch {
                    print(error)
                }
            }
        }
        
        
        for i in [1,2,3,0] {
            let composition = AVMutableComposition()
            let track = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
            do {
//                var duration = asset.duration
//                duration.value -= 880
                try track.insertTimeRange(CMTimeRange(start: kCMTimeZero, end: asset.duration), of: asset.tracks[i+1], at: kCMTimeZero)
            } catch {
                
            }
            let item = AVPlayerItem(asset: composition)
            
            let p = AVQueuePlayer(playerItem: item)
            p.volume = 0
            let l = AVPlayerLooper(player: p, templateItem: item)
            self.players.append(p)
            self.loopers.append(l)
        }
    }
    
    func play() {
        for p in players {
            p.play()
        }
    }
    
    func stop() {
        for p in players {
            p.pause()
            p.seek(to: kCMTimeZero)
        }
    }
    
    func setVolume(_ v: Float, forTrack i: Int) {
        self.players[i].volume = v
    }
    
    func mute() {
        for p in players {
            p.volume = 0
        }
    }
    
}
