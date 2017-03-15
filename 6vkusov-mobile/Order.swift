//
//  Order.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/15/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import Foundation

public enum ORDER_STATUS: String {
    case READY = "доставлен"
    case PROGRESSING = "в обработке"
    case ABORT = "отклонен"
}

class Order {
    
    private var _status: ORDER_STATUS
    private var _created: UnixTime
    private var _restaurantSlug: String
    private var _restaurantName: String
    private var _restaurantUrlIcon: String
    private var _products: [Dictionary<String, Any>]
    
    var status:ORDER_STATUS{
        return self._status
    }
    
    var created:String{
        return self._created.toDay
    }
    
    var restaurantSlug:String{
        return self._restaurantSlug
    }
    
    var restaurantName:String{
        return self._restaurantName
    }
    
    var restaurantUrlIcon:String{
        return self._restaurantUrlIcon
    }
    
    var products:[Dictionary<String, Any>]{
        return self._products
    }
    
    init(status: ORDER_STATUS, created: UnixTime, restaurantSlug: String, restaurantName: String, restaurantUrlIcon: String,products: [Dictionary<String, Any>]) {
        self._status = status
        self._created = created
        self._restaurantSlug = restaurantSlug
        self._restaurantName = restaurantName
        self._restaurantUrlIcon = restaurantUrlIcon
        self._products = products
    }

}
