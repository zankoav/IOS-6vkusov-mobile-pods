//
//  FooterProductView.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/23/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

@IBDesignable class FooterProductView: UIView {

    var view: UIView!
    
    @IBOutlet weak var button: UIButton!
    var product :Product!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    @IBAction func productAdd(_ sender: Any) {
        print("add product")
        Singleton.currentUser().getUser()?.getBasket().addOrder(product: product)
    }
    private func commonInit()
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "FooterProductView", bundle: bundle)
        self.view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        button.layer.cornerRadius = 5
        self.addSubview(self.view)
    }
    


}
