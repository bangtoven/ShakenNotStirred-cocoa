//
//  BottlesView.swift
//  test
//
//  Created by 방정호 on 2016. 12. 19..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Cocoa

//@IBDesignable
class BottlesView: NSView {

    @IBOutlet var view: NSView!
    @IBOutlet weak var stackView: NSStackView!
    
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
        if bundle.loadNibNamed("BottlesView", owner: self, topLevelObjects: nil) {
            
            self.view.frame = self.bounds
            self.addSubview(view)
        }
    }
    
    func updateWith(state: HolderState) {
        let imageViews = stackView.views as! [NSImageView]
        switch state {
        case .Error:
            for v in imageViews {
                v.imageAlignment = .alignTop
            }
        case .All:
            for v in imageViews {
                v.imageAlignment = .alignBottom
            }
        default:
            self.updateWith(state: .All)
            let i = Int(state.rawValue)
            imageViews[i].imageAlignment = .alignTop
        }
    }
}
