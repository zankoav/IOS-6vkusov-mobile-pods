//
//  PromoProduct.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 7/4/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import Foundation


class PromoProduct
{
    private var _name:String
    private var _description:String?
    private var _points:Int
    private var _iconURL: String
    private var _restaurant_slug: String
    
    var name:String{
        return _name
    }
    
    var description:String?{
        return _description
    }
    
    var restaurant_slug:String{
        return _restaurant_slug
    }
    
    var iconURL:String{
        return _iconURL
    }
    
    var points:Int{
        return _points
    }
    
    init(points: Int,name: String, url: String, restaurant_slug :String, description: String?){
        
        self._name = name
        self._description = description
        self._points = points
        self._restaurant_slug = restaurant_slug
        self._iconURL = REST_URL.SF_DOMAIN.rawValue + url
            
    }
}
