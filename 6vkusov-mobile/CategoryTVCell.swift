//
//  CategoryTVCell.swift
//  Six flavors
//
//  Created by Alexandr Zanko on 10/10/16.
//  Copyright © 2016 Netbix. All rights reserved.
//

import UIKit

class CategoryTVCell: UITableViewCell {
    
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
