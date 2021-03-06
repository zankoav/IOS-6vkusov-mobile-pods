//
//  CategoriesViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/1/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit
import SDWebImage


class CategoriesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewCategories: UITableView!
    private var main_categories:[Category] = []
    private var secoundary_categories:[Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        main_categories = Singleton.currentUser().getStore()!.getMainCategories()
        secoundary_categories = Singleton.currentUser().getStore()!.getSecoundaryCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return UIScreen.main.bounds.height/4
        }else{
            return 60.0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return main_categories.count
        }else if(section == 1){
            return secoundary_categories.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "main_category")! as! CategoryTVCell
            cell.name.text = main_categories[indexPath.row].name
            cell.icon.sd_setImage(with: URL(string: main_categories[indexPath.row].iconURL!), placeholderImage: UIImage(named:"category"))
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "secondery_category")! as UITableViewCell
            cell.textLabel?.text = secoundary_categories[indexPath.row].name
            cell.contentView.backgroundColor = UIColor.init(netHex: 0xfffdfb)
            cell.textLabel?.textColor = UIColor.gray
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantsViewController") as! RestaurantsViewController
        if (indexPath.section == 0) {
            vc.setType(slug: main_categories[indexPath.row].slug)
        }else{
            vc.setType(slug: secoundary_categories[indexPath.row].slug)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        cell.contentView.backgroundColor = UIColor.init(netHex: 0xffd4b8 )
        cell.textLabel?.textColor = UIColor.init(netHex: 0xfffdfb)
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        cell.contentView.backgroundColor = UIColor.init(netHex: 0xfffdfb)
        cell.textLabel?.textColor = UIColor.gray
    }
    



}
