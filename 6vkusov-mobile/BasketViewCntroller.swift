//
//  BasketViewCntroller.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 4/7/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class BasketViewCntroller: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    
    var basket = Singleton.currentUser().getUser()!.getBasket()
    var width = UIScreen.main.bounds.width
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chekoutView: UIView!
    
    @IBOutlet weak var totalPriceItems: UILabel!
    @IBOutlet weak var deliveryPrice: UILabel!
    @IBOutlet weak var bonusCount: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var buttonOrder: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Корзина"
        self.tableView.delegate = self
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionHeaderHeight = width/2
        self.buttonOrder.layer.masksToBounds = true
        self.buttonOrder.layer.cornerRadius = 5
        updateChekList()
        // Do any additional setup after loading the view.
    }

    @IBAction func chekOrder(_ sender: Any) {
        let chekOutViewController = self.storyboard?.instantiateViewController(withIdentifier: "CheckOrderViewController")
        self.navigationController?.pushViewController(chekOutViewController!, animated: true)    }
    
    func updateChekList(){
        totalPriceItems.text = "\(basket.getTotalPriceFromItems())"
        totalPrice.text = "\(basket.getTotalPrice())"
        bonusCount.text = "\(roundf(basket.getTotalPrice())*Float((Singleton.currentUser().getStore()?.BOUNUS_BY_BYN)!))"
        let ready = basket.isBasketReady()
        buttonOrder.isEnabled = ready
        buttonOrder.backgroundColor = ready ? UIColor(netHex: 0x8FB327) : UIColor.lightGray
        if ready{
            buttonOrder.setTitle("ОФОРМИТЬ ЗАКАЗ", for: UIControlState.normal)
        }else{
            buttonOrder.setTitle("Минимальная сумма заказа \(basket.getMinimalPrice()) руб.", for: UIControlState.normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return basket.productItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "product_item_cell") as! ProductItemTableViewCell
        
        cell.productTableVC = self
        cell.productItem = basket.productItems[indexPath.row]
        cell.name.text = basket.productItems[indexPath.row].name
        let variant = basket.productItems[indexPath.row].variant
        cell.totalPrice.text = "\(variant.price * Float(basket.productItems[indexPath.row].count))"
        cell.count.text = "\(basket.productItems[indexPath.row].count)"
        if let size = variant.size {
            cell.width.text = size
        }
        if let width = variant.weigth {
            cell.width.text = width
        }
        
        cell.icon.sd_setImage(with: URL(string: basket.productItems[indexPath.row].icon), placeholderImage: UIImage(named:"avatar"))
        
        return cell
    }

}
