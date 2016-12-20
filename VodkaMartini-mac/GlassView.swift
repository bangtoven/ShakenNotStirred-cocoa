//
//  GlassView.swift
//  test
//
//  Created by 방정호 on 2016. 12. 19..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Cocoa

class GlassView: NSView {

    @IBOutlet var view: NSView!
    @IBOutlet weak var filling: NSView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var color: NSColor = NSColor.clear {
        didSet {
            self.filling.layer?.backgroundColor = color.cgColor
        }
    }
    
    var fillRatio: CGFloat = 0 {
        didSet {
            self.heightConstraint.constant = fillRatio * self.bounds.height
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
    }
    
    private func loadFromNib() {
        let bundle = Bundle.main
        if bundle.loadNibNamed("GlassView", owner: self, topLevelObjects: nil) {
            
            self.view.frame = self.bounds
            self.addSubview(view)
        }
    }
    
}
