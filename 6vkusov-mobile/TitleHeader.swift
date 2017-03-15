//
//  TitleHeader.swift
//  Six flavors
//
//  Created by Alexandr Zanko on 05/09/16.
//  Copyright © 2016 Netbix. All rights reserved.
//

import UIKit

@IBDesignable class TitleHeader: UIView {

    var view: UIView!
    var slug:String!
    var index:Bool = true {
        didSet{
            viewMain.backgroundColor = index ? UIColor(netHex: 0xFFF8EE) : UIColor(netHex: 0xF5FBFF)
        }
    }

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameRest: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var statusOrder: UILabel!
    @IBOutlet weak var dateOrder: UILabel!
    @IBOutlet weak var buttonComments: UIButton!
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    @IBAction func comment(_ sender: Any) {
        print(slug)
    }
    
    private func commonInit()
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TitleHeader", bundle: bundle)
        self.view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //here you can add things to your view....
        self.addSubview(self.view)
    }
}
