//
//  Ext.swift
//  Six flavors
//
//  Created by Alexandr Zanko on 17/10/16.
//  Copyright © 2016 Netbix. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    
}



extension UIView {
    
    func rotate360Degrees(duration: CFTimeInterval = 1.0, completionDelegate: AnyObject? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(.pi * 2.0)
        rotateAnimation.duration = duration
        
        if let delegate: AnyObject = completionDelegate {
            rotateAnimation.delegate = delegate as? CAAnimationDelegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func dropShadow(scale: Bool = true) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 2
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

extension String {
    
    /* 
        Длинна строки
    */
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    var length: Int {
        return self.characters.count
    }
    
    /*
     Переводит строку в строку нужного формата
        var a = "2.00" - "2.00"
        var b = "2.01" - "2.01"
        var c = "2.10" - "2.10"
        var d = "2.1"  - "2.10"
        var e = "2.11" - "2.11"
        var f = "2"    - "2.00"
     */
    
    
    func twoNumbersAfterPoint()->String{
        if let g = Float(self) {
            let p = Float(lroundf(g*100))/100
            var price = "\(p)"
            if price.characters.contains(".") {
                var count = 0
                var start = false
                for character in price.characters {
                    if character == "." {
                        start = true
                        continue
                    }
                    if start {
                        count += 1
                    }
                }
                if count == 1 {
                    return "\(price)0"
                }else if count == 2 {
                    return price
                }
                else {
                    return price
                }
            }else{
                return "\(price).00"
            }
        }else{
            return "error"
        }
    }
}

extension Float {
    
    /*
     
     Округляет число до 2-ух знаков после запятой
     
     var a = 2.0001     - 2
     var b = 2.23523523 - 2.24
     var c = 2.2645346  - 2.26
     
     */
    
    func floatRoundByPoinTwo()->Float{
        return Float(lroundf(self*100))/100
    }
    
    
    func getTowNumberAfter()->String{
        let num = Int(self*100)
        let answer = num%10 == 0 ? "\(self)0" : "\(self)"
        return answer
    }
}

typealias UnixTime = Int

extension UnixTime {
    private func formatType(form: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = form
        return dateFormatter
    }
    var dateFull: Date {
        return Date(timeIntervalSince1970: Double(self))
    }
    var toHour: String {
        return formatType(form: "HH:mm").string(from: dateFull)
    }
    var toDay: String {
        return formatType(form: "MM/dd/yyyy").string(from: dateFull)
    }
}


