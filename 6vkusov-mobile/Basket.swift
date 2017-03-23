//
//  BasketUser.swift
//  Six flavors
//
//  Created by Alexandr Zanko on 25/10/16.
//  Copyright © 2016 Netbix. All rights reserved.
//

import Foundation

protocol BasketViewDelegate {
    func updateBasket(count:Int)
}

class Basket {
    
    var delegate: BasketViewDelegate?
    var products = [Product]()
    
    func addOrder(product: Product){
        print("add basket")
        products.append(product)
        print(products)
        delegate?.updateBasket(count: products.count)
    }
}
