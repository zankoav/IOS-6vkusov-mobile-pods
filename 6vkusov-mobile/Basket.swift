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
    func showaAlert(product: Product, slug: String)
}

class Basket {
    
    var delegate: BasketViewDelegate?
    var productItems = [ProductItem]()
    var slugRestaurant:String?
    
    /**
     * вызывается кнопкой заказать
     */
    func addProductFromRestaurantOrder(product: Product, slug: String){
        if productItems.count == 0 {
            slugRestaurant = slug
            addProductToBasket(product: product)
        }else{
            if slugRestaurant != slug{
                delegate?.showaAlert(product: product, slug: slug)
            }else{
                addProductToBasket(product: product)
            }
        }
    }
    
    /**
     * вызывается из алерта при согласии смены ресторана
     */
    func resetBasket(product: Product, slug: String){
        productItems = [ProductItem]()
        addProductFromRestaurantOrder(product: product, slug: slug)
        delegate?.updateBasket(count: getTotalCount())
    }
    
    
    /**
     * вызывается из корзины при добавлении варианта в корзине
     */
    func addProductItemFromBasket(productItem: ProductItem){
        if self.productItems.contains(where: { element -> Bool in
            if element.variant.id == productItem.variant.id {
                element.addCount()
                return true
            }else{
                return false
            }
        }){
            delegate?.updateBasket(count: getTotalCount())
        }
    }
    
    /**
     * вызывается из корзины при удалении количества вариантов
     */
    func minusProductItemFromBasket(id: Int){
        for itemProduct in productItems{
            if itemProduct.variant.id == id {
                if itemProduct.count > 1 {
                    itemProduct.minusCount()
                }else{
                    removeProductItem(productItem: itemProduct)
                }
            }
        }
        delegate?.updateBasket(count: getTotalCount())
    }
    
    
    /**
     * вызывается из корзины при полном удалении продукта
     */
    func removeProductItem(productItem: ProductItem){
        if let index = self.productItems.index(where: { element -> Bool in
            return productItem.id == element.id
        }){
            self.productItems.remove(at: index)
        }
        delegate?.updateBasket(count: getTotalCount())
    }
    
    private func addProductToBasket(product: Product){
        for variant in product.variants{
            if variant.count > 0 {
                if productItems.count > 0 {
                    if !self.productItems.contains(where: { element -> Bool in
                        if element.variant.id == variant.id {
                            element.addCountTo(count: variant.count)
                            return true
                        }else{
                            return false
                        }
                    }){
                        self.productItems.append(ProductItem(id: product.id, name: product.name, icon: product.icon, description: product.description!, category: product.category, variant: variant, points: product.points))
                    }
                }else{
                    self.productItems.append(ProductItem(id: product.id, name: product.name, icon: product.icon, description: product.description!, category: product.category, variant: variant, points: product.points))
                }
            }
        }
        delegate?.updateBasket(count: getTotalCount())
    }

    func getTotalCount() -> Int{
        var count = 0
        for item in productItems {
            count += item.count
        }
        return count
    }
    
    func getTotalPriceFromItems()->Float{
        var price:Float = 0.0
        for item in productItems {
            price += item.variant.price*Float(item.count)
        }
        return price
    }
    
    func getTotalPrice()->Float{
        let price = getTotalPriceFromItems()
        //  var restaurant = Singleton.currentUser().getStore()?.getRestaurantBySlugName(slug: self.slugRestaurant!)
        let deliveryPrice:Float = 0
        return price + deliveryPrice
    }
    
    func isBasketReady()->Bool{
        if let restaurant = Singleton.currentUser().getStore()?.getRestaurantBySlugName(slug: self.slugRestaurant!) {
            return getTotalPrice() - restaurant.minimal_price >= 0
        }else{
            return false
        }
    }
    
    func getMinimalPrice()-> Float{
        let restaurant = Singleton.currentUser().getStore()?.getRestaurantBySlugName(slug: self.slugRestaurant!)
        return restaurant!.minimal_price
    }
    
    func getOrderFromGeneralUser() -> [Dictionary<String, Int>]{
        var variants = [Dictionary<String, Int>]()
        for item in productItems {
            let dict = ["id":item.variant.id,"count":item.count]
            variants.append(dict)
        }
        return variants
    }
}
