//
//  SuggestTableViewCell.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/14/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class SuggestTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var button: UIButton!

    
    var slug:String?
    var controller: ProfileViewController?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        icon.layer.masksToBounds = true
        icon.layer.cornerRadius = 5
    
        // Configure the view for the selected state
    }


    @IBAction func imageButtonPressed(_ sender: Any) {
        if let vc = controller{
            vc.clickRestaurantButton(slug: slug!)
        }
    }
}
