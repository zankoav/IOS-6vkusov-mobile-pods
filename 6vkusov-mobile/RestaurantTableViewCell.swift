//
//  RestaurantTableViewCell.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/13/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var kichenType: UILabel!
    @IBOutlet weak var deliveryPrice: UILabel!
    @IBOutlet weak var deliveryTime: UILabel!
    @IBOutlet weak var likeCounts: UILabel!
    @IBOutlet weak var dislikesCounts: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var workTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    

}
