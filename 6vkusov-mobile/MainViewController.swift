//
//  ViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 2/22/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {

    @IBOutlet weak var lunchscreen: UIImageView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var logoBg: UIImageView!

    @IBOutlet weak var generalMenu: UIView!
    @IBOutlet weak var registerMenu: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoMenu: UIImageView!
    @IBOutlet weak var buttonAvatar: UIButton!
    
    var load = false
    
    private let singleton = Singleton.currentUser()

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.isEnabled = false
        buttonAvatar.isEnabled = false
        enableView(view: generalMenu,enabled: false)
        enableView(view: registerMenu,enabled: false)

        navigationController?.navigationBar.tintColor = UIColor.white
        singleton.initStore(vc: self)
        
        
        self.logoMenu.layer.cornerRadius = self.logoMenu.frame.size.width / 2
        self.logoMenu.clipsToBounds = true
        self.logoMenu.layer.borderWidth = 3.0
        self.logoMenu.layer.borderColor = UIColor.white.cgColor
        
        
        let gradient = Gradient()
        let backgroundLayer = gradient.gl
        var frame = (self.navigationController?.navigationBar.frame)!
        frame.origin.x = 0
        frame.origin.y = 0
        backgroundLayer?.frame = frame
        self.navigationController?.navigationBar.layer.insertSublayer(backgroundLayer!, at: 0)
        self.navigationController?.isNavigationBarHidden = true
    }

    public func loading(){
        
        UIView.animate(withDuration: 0.4) { () -> Void in
            self.logo.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.35, animations: {
            self.logo.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
        }) { (true) in
            if (self.load){
                let categoriesViewController = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesViewController")
                self.navigationController?.pushViewController(categoriesViewController!, animated: true)
            }else{
                self.loading()
            }
        }
    
    }
    
    public func enableView(view: UIView, enabled: Bool){
        for v in view.subviews{
            if v is UIButton{
                (v as! UIButton).isEnabled = enabled
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        lunchscreen.isHidden = true
        logo.isHidden = true
        logoBg.isHidden = true

        if(singleton.getUser()?.getStatus() != STATUS.GENERAL){
            generalMenu.isHidden = true
            enableView(view: generalMenu, enabled: false)
        }else{
            generalMenu.isHidden = false
            enableView(view: generalMenu, enabled: true)
        }
        
        if(singleton.getUser()?.getStatus() != STATUS.REGISTRED){
            registerMenu.isHidden = true
            enableView(view: registerMenu, enabled: false)
        }else{
            registerMenu.isHidden = false
            enableView(view: registerMenu, enabled: true)
        }
        
       
        
        if singleton.getUser()?.getStatus() == STATUS.GENERAL {
            logoMenu.image = UIImage(named:"user_new")
            loginButton.setTitle("Войти", for: UIControlState.normal)
            loginButton.setTitle("Войти", for: UIControlState.selected)
            loginButton.setTitle("Войти", for: UIControlState.highlighted)
        }else{
            
            let userData = singleton.getUser()?.getProfile()
            let firstName = userData?["firstName"] as? String
            
            loginButton.setTitle(firstName, for: UIControlState.normal)
            loginButton.setTitle(firstName, for: UIControlState.selected)
            loginButton.setTitle(firstName, for: UIControlState.highlighted)
            
            let img_path = userData?["img_path"] as! String
            if let avatar = userData?["avatar"] as? String {
                let url = REST_URL.SF_DOMAIN.rawValue + img_path + "/" + avatar
                
                logoMenu.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named:"user_new"))
            }

        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func profileOrLoginPressed(_ sender: Any) {
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        let profileViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserTabViewController")

            //self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController")

        singleton.getUser()?.getStatus() == STATUS.GENERAL ?
            self.navigationController?.pushViewController(loginViewController!, animated: true):
            self.navigationController?.pushViewController(profileViewController!, animated: true)
    }
    
    @IBAction func promoViewControllerPressed(_ sender: Any) {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PromoTabController") as! PromoTabController
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    
    
    public func loadComplete(){
        self.load = true
        loginButton.isEnabled = true
        buttonAvatar.isEnabled = true
        if(singleton.getUser()?.getStatus() != STATUS.GENERAL){
            enableView(view: generalMenu, enabled: false)
        }else{
            enableView(view: generalMenu, enabled: true)
        }
        
        if(singleton.getUser()?.getStatus() != STATUS.REGISTRED){
            enableView(view: registerMenu, enabled: false)
        }else{
            enableView(view: registerMenu, enabled: true)
        }
    }
    
    @IBAction func logoutUser(){
        let logoutAlert = UIAlertController(title: "Выход", message: "Вы уверены, что хотите выйти?", preferredStyle: UIAlertControllerStyle.alert)
        logoutAlert.addAction(UIAlertAction(title: "Да", style: .default, handler: { (action: UIAlertAction!) in
            let store = self.singleton.getStore()
            store?.clearDataStorage(key: (store?.APP_PROFILE)!)
            self.lunchscreen.isHidden = false
            self.logo.isHidden = false
            self.logoBg.isHidden = false
            self.loginButton.isEnabled = false
            self.buttonAvatar.isEnabled = false
            self.singleton.initStore(vc: self)
        }))
        logoutAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Отмена выхода")
        }))
        present(logoutAlert, animated: true, completion: nil)
    }
    
    @IBAction func favoritRestsPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RestaurantsViewController") as! RestaurantsViewController
            vc.setType(slug: "pizza")
            vc.isFavorite = true
            self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

