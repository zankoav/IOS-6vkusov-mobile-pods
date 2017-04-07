//
//  RestaurantMainViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/17/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit
import SDWebImage

class RestaurantMainViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, LoadJson {

    var menus = [Dictionary<String,String>]()
    var products = [Product]()
    var restaurant: Restaurant!
    
    @IBOutlet weak var tableView: UITableView!
    var widthScreen: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        widthScreen = UIScreen.main.bounds.width
        let tabController = self.tabBarController as! RestaurantTabController
        restaurant = tabController.restaurant
        
        JsonHelperLoad(url: REST_URL.SF_RESTAURANT_FOOD.rawValue, params: ["key":REST_URL.KEY.rawValue as AnyObject, "slug":restaurant.slug as AnyObject], act: self, sessionName: "food").startSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section != 0 {
            return "Меню"
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return widthScreen/1.5
        }else{
            return 28
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 0
        }else{
            return menus.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let view = RestaurantViewHeader(frame: CGRect(x: 0, y: 0, width: widthScreen, height: widthScreen/1.5))
            view.favorite.checkedImage = UIImage(named:"heart-full")!
            view.favorite.uncheckedImage = UIImage(named:"heart")!
            view.favorite.setImage(UIImage(named:"heart"), for: .normal)
            view.timeWork.text = restaurant.working_time
            let likes = restaurant.comments["likes"]!
            let dislikes = restaurant.comments["dislikes"]!
            view.likeCount.text = "\(likes)"
            view.dislikeCount.text = "\(dislikes)"
            view.icon.sd_setImage(with: URL(string:restaurant.iconURL), placeholderImage: UIImage(named:"user"))
            view.name.text = restaurant.name
            view.kitchens.text = restaurant.kitchens
            view.minPrice.text = "\(restaurant.minimal_price) руб."
            view.deliveryTime.text = restaurant.delivery_time + " мин."
            return view
        }else{
            return nil
        }
    }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_menu")
        cell?.textLabel?.text = menus[indexPath.row]["name"]
        return cell!
    }
    
    func loadComplete(obj: Dictionary<String, AnyObject>?, sessionName: String?) {
        
        if let object = obj {
            self.products = getProducts(obj: object)
            if products.count > 0 {
                self.menus = getMenu(products: self.products)
            }
            if self.menus.count > 0 && self.products.count > 0 {
                self.tableView.reloadData()
            }
        }
    }
    
    private func getProducts(obj: Dictionary<String, AnyObject>) -> [Product]{
        var prods = [Product]()
        if let array = obj["food"] as? [Dictionary<String,AnyObject>] {
            let img_path = "\(REST_URL.SF_DOMAIN.rawValue)/\(obj["img_path"] as! String)/"
            for ar in array {
                let id = ar["id"] as! Int
                let name = ar["name"] as! String
                let points  = ar["points"] as? Int
                let description = ar["description"] as? String ?? ""
                var imageUrl = img_path
                if let image = ar["image"] as? String {
                    imageUrl += image
                }
                let category = ar["category"] as! Dictionary<String,String>
                var variants = [Variant]()
                if let vars = ar["variants"] as? [Dictionary<String,AnyObject>] {
                    for vs in vars {
                        let id = vs["id"] as! Int
                        let price = vs["price"] as! Float
                        let size = vs["size"] as? String
                        let weigth = vs["weigth"] as? String
                        variants.append(Variant(id: id, price: price, size: size, weigth: weigth))
                    }
                }
                let product = Product(id: id, name: name, icon: imageUrl, description: description, category:category, variants: variants, points:points)
                
                prods.append(product)
            }
        }

        return prods
    }
    
    private func getMenu(products:[Product]) -> [Dictionary<String,String>]{
        var menu = [Dictionary<String,String>]()
        var array = [String]()
        let points = ["slug":"free_food","name":"Еда за баллы"]
        var isFreeFoodExists = false
        for product in products {
            if product.points != nil {
                isFreeFoodExists = true
            }
            let categorySlug = product.category["slug"]!
            if !array.contains(categorySlug){
                array.append(categorySlug)
                menu.append(product.category)
            }
        }
        if isFreeFoodExists {
            menu.insert(points, at: 0)
        }
        return menu
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductsTableViewController") as! ProductsTableViewController
        vc.restaurant = restaurant
        
        if let slug = menus[indexPath.row]["slug"] {
            vc.products = slug == "free_food" ? getFreeFood() : getProdsByCat(slug: slug)
            vc.isFreeFood = slug == "free_food"
            vc.titleCat = menus[indexPath.row]["name"]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    private func getProdsByCat(slug: String) ->[Product]{
        var prods = [Product]()
        for pr in self.products {
            if pr.category["slug"] == slug {
                prods.append(pr)
            }
        }
        return prods
    }
    
    private func getFreeFood() ->[Product]{
        var prods = [Product]()
        for pr in self.products {
            if pr.points != nil {
                prods.append(pr)
            }
        }
        return prods
    }

}
