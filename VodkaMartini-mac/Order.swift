//
//  Order.swift
//  VodkaMartini
//
//  Created by 방정호 on 2016. 12. 19..
//  Copyright © 2016년 Bangtoven. All rights reserved.
//

import Foundation

class Order {
    static var currentOrder: Order?
    
    var bartenderName: String?
    var resultMix: [Float] = [0,0,0,0]
    
    var customerName: String?
    var stemFilePath: String?
    var orderMix: [Float] = [0,0,0,0]
}
