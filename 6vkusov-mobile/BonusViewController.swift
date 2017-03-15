//
//  BonusViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/14/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class BonusViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var friendAddress: UITextField!
    @IBOutlet weak var callFriendButton: UIButton!
    
    private var orders:[Order] = []
    private var userData = Singleton.currentUser().getUser()!.getProfile()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        self.view.addGestureRecognizer(theTap)
        
        callFriendButton.layer.masksToBounds = true
        callFriendButton.layer.cornerRadius = callFriendButton.bounds.height/2
        
        orders = [
            Order(status: ORDER_STATUS.PROGRESSING, created: 1470075992, restaurantSlug: "primecafe", restaurantName: "Prime cafe", restaurantUrlIcon: "\(REST_URL.SF_DOMAIN.rawValue)/uploads/img/promo/58811668cd4df.png", products: [["name":"Пицца", "count": 1], ["name":"Кола 1 л.", "count": 2], ["name":"Бургер", "count": 2]]),
            Order(status: ORDER_STATUS.READY, created: 1470060000, restaurantSlug: "gruzin.by", restaurantName: "Грузин.by", restaurantUrlIcon: "\(REST_URL.SF_DOMAIN.rawValue)/uploads/img/promo/58811668cd4df.png", products: [["name":"Суши", "count": 8], ["name":"Кола 1 л.", "count": 2], ["name":"Суши", "count": 32]]),
            Order(status: ORDER_STATUS.ABORT, created: 1460050000, restaurantSlug: "primecafe", restaurantName: "Prime cafe", restaurantUrlIcon: "\(REST_URL.SF_DOMAIN.rawValue)/uploads/img/promo/58811668cd4df.png", products: [["name":"Роллы", "count": 16], ["name":"Шашлык", "count": 1], ["name":"Стейк", "count": 2]]),
            Order(status: ORDER_STATUS.READY, created: 1450020000, restaurantSlug: "gruzin.by", restaurantName: "Грузин.by", restaurantUrlIcon: "\(REST_URL.SF_DOMAIN.rawValue)/uploads/img/promo/58811668cd4df.png", products: [["name":"Пицца", "count": 5], ["name":"Кола 2 л.", "count": 1], ["name":"Суши", "count": 8]]),
            Order(status: ORDER_STATUS.READY, created: 1440010000, restaurantSlug: "primecafe", restaurantName: "Prime cafe", restaurantUrlIcon: "\(REST_URL.SF_DOMAIN.rawValue)/uploads/img/promo/58811668cd4df.png", products: [["name":"Паста", "count": 1], ["name":"Фанта 0.5 л.", "count": 1], ["name":"Бургер", "count": 2]]),
            Order(status: ORDER_STATUS.ABORT, created: 1430000000, restaurantSlug: "gruzin.by", restaurantName: "Грузин.by", restaurantUrlIcon: "\(REST_URL.SF_DOMAIN.rawValue)/uploads/img/promo/58811668cd4df.png", products: [["name":"Стейк", "count": 3], ["name":"Суп", "count": 1], ["name":"Пицца", "count": 1]])
        ]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders[section].products.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.height/5
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = TitleHeader(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/5))
        sectionView.index = section%2 == 0
        sectionView.slug = orders[section].restaurantSlug
        
        sectionView.dateOrder.text = orders[section].created
        let status = orders[section].status
        if status == ORDER_STATUS.PROGRESSING{
            sectionView.statusOrder.textColor = UIColor(netHex: 0xCA6A00)
        }else if(status == ORDER_STATUS.ABORT){
            sectionView.statusOrder.textColor = UIColor(netHex: 0xBE232D)
        }else{
            sectionView.buttonComments.isHidden = false
            sectionView.statusOrder.textColor = UIColor(netHex: 0x8FB327)
        }
        sectionView.statusOrder.text = status.rawValue
        sectionView.nameRest.text = orders[section].restaurantName
        sectionView.imageView.sd_setImage(with: URL(string: orders[section].restaurantUrlIcon), placeholderImage: UIImage(named:"checkBoxOn"))
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "order_cell") as! OrderTableViewCell
        cell.name.text = orders[indexPath.section].products[indexPath.row]["name"] as? String
        cell.count.text = "\(orders[indexPath.section].products[indexPath.row]["count"] as! Int)"
        return cell
    }
    
    func scrollViewTapped(recognizer: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func callFriendPressed(_ sender: Any) {
        let email = self.friendAddress.text
        callFriendButton.isEnabled = false
        if(!Validator.email(email: email!)){
            alertShow(textError: "Не верный формат email")
            callFriendButton.isEnabled = true
            return
        }else{
            print("send \(email)")
        }
    }
    
    
}
