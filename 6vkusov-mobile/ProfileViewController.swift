//
//  ProfileViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/3/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var bonusUser: UILabel!
    @IBOutlet weak var imageUser: UIImageView!
    @IBOutlet weak var saggestsTableView: UITableView!
    
    private var seggests:[Suggest] = []
    private var heightCell:CGFloat = 0
    
    private var userData = Singleton.currentUser().getUser()!.getProfile()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "Профиль"
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightCell = UIScreen.main.bounds.height/3
        seggests = [
            Suggest(name: "ШЕФ-БУРГЕР",url: "/uploads/img/promo/58811668cd4df.png", slug: "osushi"),
            Suggest(name: "ШЕФ-БУРГЕР",url: "/uploads/img/promo/58811668cd4df.png", slug: "osushi"),
            Suggest(name: "ШЕФ-БУРГЕР",url: "/uploads/img/promo/58811668cd4df.png", slug: "osushi"),
            Suggest(name: "ШЕФ-БУРГЕР",url: "/uploads/img/promo/58811668cd4df.png", slug: "osushi")
        ]
        initViews()
    }

    private func initViews(){
        
        bonusUser.layer.masksToBounds = true
        bonusUser.layer.cornerRadius = 5
        
        imageUser.layer.masksToBounds = true
        imageUser.layer.cornerRadius = imageUser.bounds.width/2
        
        let firstName = userData?["firstName"] as! String
        let lastName = userData?["lastName"] as! String
        nameUser.text = firstName + " " + lastName
        
        let points = userData?["points"] as! Int
        bonusUser.text = "\(points) баллов    "
        
        let img_path = userData?["img_path"] as! String
        if let avatar = userData?["avatar"] as? String {
            let url = REST_URL.SF_DOMAIN.rawValue + img_path + "/" + avatar
            imageUser.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named:"checkBoxOn"))
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.seggests.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heightCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Персональные предложения"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "suggest_cell") as! SuggestTableViewCell
        cell.name.text = seggests[indexPath.row].name
        cell.icon.sd_setImage(with: URL(string: seggests[indexPath.row].iconURL), placeholderImage: UIImage(named:"checkBoxOn"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantsViewController") as! RestaurantsViewController
        vc.setType(slug: seggests[indexPath.row].slug)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    

}
