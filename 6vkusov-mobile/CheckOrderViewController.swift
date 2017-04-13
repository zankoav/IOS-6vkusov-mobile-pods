//
//  CheckOrderViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 4/7/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit
import SCLAlertView

class CheckOrderViewController: BaseViewController, UITextFieldDelegate, LoadJson{
    
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var totalPoints: UILabel!

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var mobile: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    private var textFieldActive:UITextField?
    private let user = Singleton.currentUser().getUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes = [NSForegroundColorAttributeName: UIColor.lightGray]
        name.attributedPlaceholder = NSAttributedString(string: "Имя", attributes:attributes)
        mobile.attributedPlaceholder = NSAttributedString(string: "Телефон", attributes:attributes)
        address.attributedPlaceholder = NSAttributedString(string: "Адрес", attributes:attributes)
        // Do any additional setup after loading the view.
        let theTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        self.view.addGestureRecognizer(theTap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        if user?.getStatus() == STATUS.REGISTRED {
            
            if let nameUser = user?.getProfile()?["firstName"] as? String{
                self.name.text = nameUser
                if let lastName = user?.getProfile()?["lastName"] as? String{
                    self.name.text = "\(nameUser) \(lastName)"
                }
            }
            
            if let phoneUser = user?.getProfile()?["phone"] as? String{
                mobile.text = "+375\(phoneUser)"
            }
            
        }
        let price = user!.getBasket().getTotalPrice()
        totalPrice.text = price.getTowNumberAfter()
        totalPoints.text = "\(user!.getBasket().getTotalPoints())"

    }
    
    func loadComplete(obj: Dictionary<String, AnyObject>?, sessionName: String?) {
        print(obj)
        if let response = obj {
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                showCloseButton: false
            )
            
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("Ok"){
                for vc in (self.navigationController?.viewControllers)! {
                    if vc.restorationIdentifier == "RestaurantTabController"{
                        self.navigationController?.popToViewController(vc, animated: true)
                        break
                    }
                }
            }
            if (sessionName == "send_general_order"){
                let code = response["status"] as! String
                if code == "successful" {
                    self.sendButton.isEnabled = true
                    Singleton.currentUser().getUser()?.getBasket().productItems = [ProductItem]()
                    let price = response["totalPrice"] as! Float
                    alert.showSuccess("Заказ принят!", subTitle: "Ваш заказ №\(response["order"] as! Int), через несколько минут Вам перезвонит оператор, сумма заказа \(price.getTowNumberAfter()) рублей")
                }else{
                    self.sendButton.isEnabled = true
                }
            }else{
                let price = response["totalPrice"] as! Float
                alert.showSuccess("Заказ принят!", subTitle: "Ваш заказ №\(response["order"] as! Int), через несколько минут Вам перезвонит оператор, сумма заказа \(price.getTowNumberAfter()) рублей")
            }
        }else{
            alertShow(textError: "Ошибка соединения ...")
            self.sendButton.isEnabled = true
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewTapped(recognizer: UIGestureRecognizer) {
        self.view.endEditing(true)
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldActive = textField
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            if let field = textFieldActive {
                let delta:CGFloat = 40
                let fieldHeight = field.frame.height
                let fieldYPosition = field.frame.origin.y
                let viewHeight = view.frame.height
                let viewYposition = view.frame.origin.y
                let keyboardH = keyboardSize.height
                let distance = viewHeight - (fieldYPosition + fieldHeight + delta) - keyboardH - viewYposition
                if distance < 0{
                    self.view.frame.origin.y += distance
                }
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
    @IBAction func sendOrder(_ sender: Any) {
        self.sendButton.isEnabled = false
        let fio = self.name.text
        let phone = self.mobile.text
        let address = self.address.text
        if Singleton.currentUser().getUser()?.getStatus() == STATUS.GENERAL {
            let variants = Singleton.currentUser().getUser()?.getBasket().getOrderFromGeneralUser()
            sendHashToTheServerFromGeneralUser(fio: fio!, phone: phone!, address: address!, variants: variants!)
        }
        if Singleton.currentUser().getUser()?.getStatus() == STATUS.REGISTRED {
            let session = Singleton.currentUser().getUser()?.getProfile()?["session"] as! String
            sendHashToTheServerFromRegisterUser(fio: fio!, phone: phone!, address: address!, session: session)

        }
    }
    
    private func sendHashToTheServerFromGeneralUser(fio:String,phone:String,address:String,variants:[Dictionary<String,Int>]){
        var dict = Dictionary<String,AnyObject>()
        dict["fio"]  = fio as AnyObject
        dict["key"]  = REST_URL.KEY.rawValue as AnyObject
        dict["phone"] = phone as AnyObject
        dict["address"]  = address as AnyObject
        dict["variants"]  = variants as AnyObject

        JsonHelperLoad(url: REST_URL.SF_SEND_ORDER.rawValue, params: dict, act: self, sessionName: "send_general_order").startSession()
    }
    
    private func sendHashToTheServerFromRegisterUser(fio:String,phone:String,address:String,session:String){
        var dict = Dictionary<String,AnyObject>()
        dict["fio"]  = fio as AnyObject
        dict["key"]  = REST_URL.KEY.rawValue as AnyObject
        dict["phone"] = phone as AnyObject
        dict["address"]  = address as AnyObject
        dict["deliveryType"] = 1 as AnyObject  // ???
        dict["session"]  = session as AnyObject

        JsonHelperLoad(url: REST_URL.SF_CHECKOUT_CART.rawValue, params: dict, act: self, sessionName: "send_register_order").startSession()
    }


}
