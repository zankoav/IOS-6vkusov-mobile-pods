//
//  ProductsTableViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/17/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController, BasketViewDelegate  {

    var titleCat: String!
    var restaurant: Restaurant!
    var products = [Product]()
    private var isFreeFood = false
    
    
    private var button:UIBarButtonItem?
    private var label:UILabel!
    var width = UIScreen.main.bounds.width
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Singleton.currentUser().getUser()?.getBasket().delegate = self
        label.text = "1"
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isFreeFood = titleCat == "Еда за баллы" ? true : false
        self.title = titleCat
        
        self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension
        self.tableView.estimatedSectionHeaderHeight = width/2
        
        let containView = UIView(frame: CGRect(x:0, y:0,width:70, height:40))
        label = UILabel(frame: CGRect(x:40, y:5, width:20, height:20))
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(netHex: 0x8FB327)
        label.layer.masksToBounds = true
        label.font = UIFont.systemFont(ofSize: 9)
        label.layer.cornerRadius = label.bounds.height/2
        label.textAlignment = NSTextAlignment.center
        containView.addSubview(label)
        let imageButton = UIButton(frame: CGRect(x:0, y:5, width:70, height:30))
        imageButton.addTarget(self, action: #selector(basketOpen), for: UIControlEvents.touchUpInside)
        imageButton.setImage(UIImage(named: "shopping-cart"), for: UIControlState.normal)
        imageButton.contentMode = UIViewContentMode.scaleAspectFill
        containView.addSubview(imageButton)
        containView.addSubview(label)
        button = UIBarButtonItem(customView: containView)
        self.navigationItem.rightBarButtonItem = button
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func updateBasket(count: Int) {
        label.text = "\(count)"
    }
    
    func basketOpen(){
        let basketTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "BasketTableViewController")
        self.navigationController?.pushViewController(basketTableViewController!, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return products.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products[section].variants.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "product_cell") as! VariantTableViewCell
        let variant = products[indexPath.section].variants[indexPath.row]
        cell.variant = products[indexPath.section].variants[indexPath.row]
        
        cell.price.text = variant.count == 0 ? "\(variant.price)" : "\(Float(variant.count)*variant.price)"
        if let size = variant.size {
            cell.desc.text = size
        }
        if let width = variant.weigth {
            cell.desc.text = width
        }
        cell.count.text = "\(variant.count)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! ProductHeaderViewCell
        cell.name.text = products[section].name
        cell.desc.text = products[section].descriptionProduct
        cell.icon.sd_setImage(with: URL(string: products[section].icon), placeholderImage: UIImage(named:"avatar"))
        return cell.contentView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = FooterProductView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
            view.product = products[section]
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "footer") as! ProductFooterCell
//        cell.add.layer.cornerRadius = 5
//        cell.product = products[section]
//        return cell.contentView
//        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60.0
    }
}
