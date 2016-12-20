//
//  ReplaceSegue.swift
//  test
//
//  Created by 방정호 on 2016. 12. 16..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Cocoa

class ReplaceSegue: NSStoryboardSegue {
    override func perform() {
        if let fromViewController = sourceController as? NSViewController {
            if let toViewController = destinationController as? NSViewController {
                fromViewController.view.window?.contentViewController = toViewController
            }
        }
    }
}
