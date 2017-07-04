//
//  ProfileViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/3/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, LoadJson {
    
    @IBOutlet weak var saggestsTableView: UITableView!
    
    private var seggests:[Suggest] = []
    private var promoProducts:[PromoProduct] = []

    private var heightCell:CGFloat = 0
    var widthScreen = UIScreen.main.bounds.width
    var viewHeader = ProfileViewHeader()

    private var userData = Singleton.currentUser().getUser()!.getProfile()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "Профиль"
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewHeader.controller = self
        
        JsonHelperLoad(url: REST_URL.SF_FOOD_POINTS.rawValue, params: ["key":REST_URL.KEY.rawValue as AnyObject], act: self, sessionName: REST_URL.SF_FOOD_POINTS.rawValue).startSession()
    
    }
    
    func loadComplete(obj: Dictionary<String, AnyObject>?, sessionName: String?) {
        if let request = obj {
            if sessionName == REST_URL.SF_FOOD_POINTS.rawValue{
                if let status = request["status"] as? String {
                    if status == "successful" {
                        print("status")
                        if let items = request["items"] as? [AnyObject]{
                            print("items")
                            let image_path = request["image_path"] as? String
                            for item in items {
                                let name = item["name"] as! String
                                let slug = item["restaurant_slug"] as! String
                                let points = item["points"] as! Int
                                let icon = item["icon"] as! String
                                let description = item["description"] as? String
                                
                                self.promoProducts.append(PromoProduct(points: points, name: name, url: image_path!+"/"+icon, restaurant_slug: slug, description: description))
                            }
                            self.saggestsTableView.reloadData()
                        }
                    }
                }
                
            }
        }

    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 0
        }else{
            return self.promoProducts.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 190
        }else{
            return 28
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section != 0 {
            return "Предложения"
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            let firstName = userData?["firstName"] as! String
            if let lastName = userData?["lastName"] as? String {
                viewHeader.name.text = firstName + " " + lastName
            }else{
                viewHeader.name.text = firstName
            }
            let img_path = userData?["img_path"] as! String
            if let avatar = userData?["avatar"] as? String {
                let url = REST_URL.SF_DOMAIN.rawValue + img_path + "/" + avatar
                viewHeader.icon.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named:"user_new"))
            }
            
            if let email = userData?["email"] as? String {
                viewHeader.email.text = email
            }
            
            if let phone = userData?["phone"] as? String {
                viewHeader.phone.text = "+375\(phone)"
            }
        
            return viewHeader
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "suggest_cell") as! SuggestTableViewCell
        cell.slug = promoProducts[indexPath.row].restaurant_slug
        cell.controller = self
        cell.name.text = promoProducts[indexPath.row].name
        cell.points.text = "\(promoProducts[indexPath.row].points) баллов"
        cell.icon.sd_setImage(with: URL(string: promoProducts[indexPath.row].iconURL), placeholderImage: UIImage(named:"product"))
        return cell
    }
    
    func clickCallFriends() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "BonusViewController") as! BonusViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func clickSettingsChange(){
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsUserViewController") as! SettingsUserViewController
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func clickRestaurantButton(slug:String){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantTabController") as! RestaurantTabController
        if let restaurant = Singleton.currentUser().getStore()!.getRestaurantBySlugName(slug:slug) {
            vc.restaurant = restaurant
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }


}
