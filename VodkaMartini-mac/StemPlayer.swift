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
    
    static private var _shared: StemPlayer?
    static var shared: StemPlayer? {
        if _shared != nil {
            return _shared
        } else {
            let url = Order.current.stemFilePath ?? URL(fileURLWithPath: Bundle.main.path(forResource: "master.stem", ofType: "mp4")!)
            _shared = StemPlayer(url: url)
            return _shared
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
                    self.stemData?.remove(at: 0)
                } catch {
                    print(error)
                }
            }
        }
        
        
        for i in [1,2,3,0] {
            let composition = AVMutableComposition()
            let track = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
            do {
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
