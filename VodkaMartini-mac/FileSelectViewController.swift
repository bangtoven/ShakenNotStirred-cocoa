//
//  FileSelectViewController.swift
//  VodkaMartini
//
//  Created by 방정호 on 2016. 12. 20..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Cocoa
import AVKit
import AVFoundation

class FileSelectViewController: NSViewController {

    @IBOutlet weak var playerView: AVPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.playerView.controlsStyle = .none
//        self.playerView.showsFullScreenToggleButton = true
        self.playerView.player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "vodkamartini-video", ofType: "mov")!))
//        self.playerView.player?.play()
    }
    
    @IBAction func makeAnOrder(_ sender: NSButton) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["mp4"]
        openPanel.title = "Menu"
        openPanel.message = "Select what you want to MIX."
        let fi = openPanel.runModal()
        if(fi == NSFileHandlingPanelOKButton){
            if openPanel.url?.path.contains("Vodka") == true {
                Order.current.stemFilePath = openPanel.url
                self.performSegue(withIdentifier: "replace", sender: nil)
                self.playerView.player = nil
            } else {
                let alert = NSAlert.init()
                alert.messageText = "Not Vodka Martini?"
                alert.informativeText = "How about martini as usual?"
                alert.addButton(withTitle: "OK. Vodka martini.")
                alert.addButton(withTitle: "No, I want this.")
                let ai = alert.runModal()
                if ai != 1000 {
                    Order.current.stemFilePath = openPanel.url
                    self.performSegue(withIdentifier: "replace", sender: nil)
                    self.playerView.player = nil
                }
            }
        }
    }
    
    
    
}
