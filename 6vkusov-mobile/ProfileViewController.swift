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
    private var heightCell:CGFloat = 0
    var widthScreen = UIScreen.main.bounds.width
    var viewHeader = ProfileViewHeader()

    
    private var userData = Singleton.currentUser().getUser()!.getProfile()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "Профиль"
    }

    func loadComplete(obj: Dictionary<String, AnyObject>?, sessionName: String?) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightCell = UIScreen.main.bounds.height/3
        
        seggests = [
            Suggest(name: "ШЕФ-БУРГЕР",url: "/uploads/img/promo/58811668cd4df.png", slug: "3-povara"),
            Suggest(name: "ШЕФ-БУРГЕР",url: "/uploads/img/promo/58811668cd4df.png", slug: "3-povara"),
            Suggest(name: "ШЕФ-БУРГЕР",url: "/uploads/img/promo/58811668cd4df.png", slug: "3-povara"),
            Suggest(name: "ШЕФ-БУРГЕР",url: "/uploads/img/promo/58811668cd4df.png", slug: "3-povara")
        ]
        
        initViews()
    }

    private func initViews(){
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 0
        }else{
            return self.seggests.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightCell
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
        cell.name.text = seggests[indexPath.row].name
        cell.icon.sd_setImage(with: URL(string: seggests[indexPath.row].iconURL), placeholderImage: UIImage(named:"product"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantTabController") as! RestaurantTabController
        print(seggests[indexPath.row].slug)
        
        if let restaurant = Singleton.currentUser().getStore()!.getRestaurantBySlugName(slug:seggests[indexPath.row].slug) {
            vc.restaurant = restaurant
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
