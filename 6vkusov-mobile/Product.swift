//
//  Product.swift
//  Six flavors
//
//  Created by Alexandr Zanko on 20/10/16.
//  Copyright © 2016 Netbix. All rights reserved.
//

import Foundation

class Product {
    
    private var _id: Int
    private var _name: String
    private var _icon:String
    private var _description: String
    private var _category: String
    private var _variants:[Variant]
    
    var id: Int{
        return _id
    }
    
    var name: String{
        return _name
    }
    
    var category: String{
        return _category
    }
    
    var variants: [Variant]{
        return _variants
    }
    
    var icon: String {
        return _icon
    }
    
    var descriptionProduct: String?{
        return _description
    }

    
    init(id :Int, name: String, icon: String, description: String, category: String,  variants:[Variant]){
        _id = id
        _name = name
        _icon = icon
        _description = description
        _category = category
        _variants = variants
    }
    
}
