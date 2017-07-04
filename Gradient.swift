//
//  Gradient.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 6/13/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class Gradient {
    var gl:CAGradientLayer!
    
    init() {
        let colorBottom = UIColor.init(netHex: 0x591211).cgColor
        let colorCenter = UIColor.black.cgColor
        let colorTop = UIColor.black.cgColor
        
        self.gl = CAGradientLayer()
        self.gl.colors = [colorTop, colorCenter, colorBottom]
        self.gl.locations = [0.0, 0.5, 1.0]
    }
}
