//
//  RestaurantsViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/13/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class RestaurantsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var restaurantsFiltred = [Restaurant]()
    
    @IBOutlet weak var heightTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    private var restaurants = [Restaurant]()
    private var searchController:UISearchController!
    private var resultsController = UITableViewController()
    private var slug:String!
    private var isFilterOpen = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurants = Singleton.currentUser().getStore()!.getAllRestaurants()
        
        log(logMessage: self.slug)
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        //        let rightSearchBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(RestaurantsTableViewController.searchTapped))
        //        self.navigationItem.rightBarButtonItem = rightSearchBarButtonItem
        
        self.resultsController.tableView.delegate = self
        self.resultsController.tableView.dataSource = self
        
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.searchController.searchBar.placeholder = "Поиск ресторана"
        self.searchController.searchBar.setValue("Отмена", forKey: "cancelButtonText")
        self.searchController.searchResultsUpdater = self
        self.tableView.tableHeaderView = self.searchController.searchBar
        
    }
    
    @IBAction func filterTapped(_ sender: Any) {
        self.heightTableViewConstraint.constant = isFilterOpen ? 0: -170
        isFilterOpen = !isFilterOpen
        UIView.animate(withDuration: 0.5) {self.view.layoutIfNeeded()}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        self.restaurantsFiltred = self.restaurants.filter{(restaurant:Restaurant)->Bool in
            if (restaurant.name.capitalized).contains(self.searchController.searchBar.text!.capitalized) {
                return true
            }else{
                return false
            }
        }
        self.resultsController.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UIScreen.main.bounds.height/4
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if tableView == self.tableView{
            return self.restaurants.count

        }else{
            return self.restaurantsFiltred.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "restaurant_cell", for: indexPath) as!RestaurantTableViewCell
            var restaurant = restaurants[indexPath.row]
            cell.name.text = restaurant.name
            cell.kichenType.text = restaurant.getKitchens()
            cell.deliveryPrice.text = "\(restaurant.minimal_price) руб"
            cell.deliveryTime.text = "\(restaurant.delivery_time) мин"
            let likes = restaurant.comments["like"]!
            let dislikes = restaurant.comments["total"]! - likes
            cell.likeCounts.text = "\(likes)"
            cell.dislikesCounts.text = "\(dislikes)"
            cell.icon.sd_setImage(with: URL(string: restaurants[indexPath.row].iconURL), placeholderImage: UIImage(named:"checkBoxOn"))
            return cell
        }else{
            let cell = UITableViewCell()
            var restaurant = restaurantsFiltred[indexPath.row]
            cell.textLabel?.text = restaurant.name
//            cell.name.text = restaurant.name
//            cell.kichenType.text = restaurant.getKitchens()
//            cell.deliveryPrice.text = "\(restaurant.minimal_price) руб"
//            cell.deliveryTime.text = "\(restaurant.delivery_time) мин"
//            let likes = restaurant.comments["like"]!
//            let dislikes = restaurant.comments["total"]! - likes
//            cell.likeCounts.text = "\(likes)"
//            cell.dislikesCounts.text = "\(dislikes)"
//            cell.icon.sd_setImage(with: URL(string: restaurants[indexPath.row].iconURL), placeholderImage: UIImage(named:"checkBoxOn"))
            return cell
        }
        
        
    }
    
    
    
    func setType(slug: String){
        self.slug =  slug
    }

}
