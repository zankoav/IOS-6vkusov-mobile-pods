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

    var menus = [String]()
    var products = [Product]()
    var restaurant: Restaurant!
    
    @IBOutlet weak var tableView: UITableView!
    var widthScreen: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        widthScreen = UIScreen.main.bounds.width
        let tabController = self.tabBarController as! RestaurantTabController
        restaurant = tabController.restaurant
        JsonHelperLoad(url: REST_URL.SF_RESTAURANT_MENU.rawValue, params: ["slug":restaurant.slug], act: self, sessionName: nil).startSession()
        JsonHelperLoad(url: REST_URL.SF_RESTAURANT_FOOD.rawValue, params: ["slug":restaurant.slug], act: self, sessionName: "food").startSession()
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
            let likes = restaurant.comments["like"]!
            let dislikes = restaurant.comments["total"]! - likes
            view.likeCount.text = "\(likes)"
            view.dislikeCount.text = "\(dislikes)"
            view.icon.sd_setImage(with: URL(string:restaurant.iconURL), placeholderImage: UIImage(named:"user"))
            view.name.text = restaurant.name
            view.kitchens.text = restaurant.kitchens.joined(separator: ", ")
            view.minPrice.text = "\(restaurant.minimal_price) руб."
            view.deliveryTime.text = restaurant.delivery_time + " мин."
            return view
        }else{
            return nil
        }
    }
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_menu")
        cell?.textLabel?.text = menus[indexPath.row]
        return cell!
    }
    
    func loadComplete(obj: Dictionary<String, AnyObject>?, sessionName: String?) {
        if sessionName == "food" {
            self.products = getAllProducts(obj: obj)
        }else{
            if let array = obj?["categories"] as? [String] {
                self.menus = array
            }
        }
        if self.menus.count > 0 && self.products.count > 0 {
            self.tableView.reloadData()
        }
    }
    
    func getAllProducts (obj: Dictionary<String, AnyObject>?) -> [Product]{
        var prods = [Product]()
        if let array = obj?["food"] as? [Dictionary<String,AnyObject>] {
            for ar in array {
                var img_path = "\(REST_URL.SF_DOMAIN.rawValue)/\(obj?["img_path"] as! String)/"
                let id = ar["id"] as! Int
                let name = ar["name"] as! String
                let descrip = ar["description"] as? String ?? ""
                if let image = ar["image"] as? String {
                    img_path += image
                }
                let category = ar["category"] as! String
                
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
                let product = Product(id: id, name: name, icon: img_path, description: descrip, category:category, variants: variants)
                
                prods.append(product)
            }
        }
        return prods
    }
    
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductsTableViewController") as! ProductsTableViewController
        vc.restaurant = restaurant
        vc.products = getProdsByCat(name: menus[indexPath.row])
        vc.titleCat = menus[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getProdsByCat(name: String) ->[Product]{
        var prods = [Product]()
        for pr in self.products {
            if pr.category == name {
                prods.append(pr)
            }
        }
        return prods
    }

}
