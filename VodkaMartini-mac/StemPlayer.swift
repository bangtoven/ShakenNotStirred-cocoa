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
        
        
        for i in 0..<4 {
            let composition = AVMutableComposition()
            let track = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
            do {
                var duration = asset.duration
                duration.value -= 660
                try track.insertTimeRange(CMTimeRange(start: kCMTimeZero, end: asset.duration), of: asset.tracks[i+1], at: kCMTimeZero)
            } catch {
                
            }
            let item = AVPlayerItem(asset: composition)
            
            let p = AVQueuePlayer(playerItem: item)
//            p.volume = 0
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
    
    func setVolume(_ v: Float, forTrack i: Int) {
        self.players[i].volume = v
    }
    
}
