//
//  RestaurantViewHeader.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/20/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

@IBDesignable class RestaurantViewHeader: UIView {

    var view: UIView!
    
    @IBOutlet weak var timeWork: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var dislikeCount: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var kitchens: UILabel!
    @IBOutlet weak var minPrice: UILabel!
    @IBOutlet weak var deliveryTime: UILabel!
    
    @IBOutlet weak var favorite: CheckBox!

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit()
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RestaurantViewHeader", bundle: bundle)
        self.view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(self.view)
    }


}
