//
//  SliderAppInterface.swift
//  test
//
//  Created by 방정호 on 2016. 12. 19..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Cocoa
import Swifter

protocol SliderAppInterfaceDelegate {
    func sliderAppUpdate(index: Int, value: Float)
}

class SliderAppInterface {
    static let sharedInstance = SliderAppInterface()
    var server: HttpServer!
    var delegate: SliderAppInterfaceDelegate?
    
    init() {
        self.server = HttpServer()
        
//        server["stems"] = { request in
//            return HttpResponse.ok(.json(StemPlayer.shared?.stemData as AnyObject))
//        }
        
//        server["files"] = { request in
//            let paths = Bundle.main.paths(forResourcesOfType: "mp4", inDirectory: nil)
//            let names = paths.map({ (p) -> String in
//                return URL(fileURLWithPath: p).lastPathComponent
//            })
//            
//            return HttpResponse.ok(.json(names as! AnyObject))
//        }
        
        server["update"] = { request in
            if let p = request.queryParams.last {
                let i = Int(p.0)!
                let v = Float(p.1)!/Float(255.0)
                self.delegate?.sliderAppUpdate(index: i, value: v)
            }
            return .accepted
        }
        
        do {
            try server.start(8080)
        } catch {
            print(error)
        }
    }
}
