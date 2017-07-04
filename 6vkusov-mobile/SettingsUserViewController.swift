//
//  SettingsUserViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/15/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class SettingsUserViewController: BaseViewController, UITextFieldDelegate, LoadJson { 
    
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var fmale: UITextField!
    @IBOutlet weak var phone: UITextField!
    private var textFieldActive:UITextField?
    
    @IBOutlet weak var saveBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let nav = self.navigationController {
            nav.navigationBar.items?[1].title = ""
        }
        initViews()
        let theTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        self.view.addGestureRecognizer(theTap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        let name = self.name.text?.trim()
        let fmale = self.fmale.text?.trim()
        let phone = self.phone.text?.trim()
        
        saveBtn.isEnabled = false
        if(!Validator.minLength(password: name!,length: 2)){
            let alert = UIAlertController(title: "Ошибка", message: "Слишком короткое имя", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.saveBtn.isEnabled = true
            return
        }else if(!Validator.nameLiterals(name: name!)){
            let alert = UIAlertController(title: "Ошибка", message: "Имя должно состоять только из букв", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.saveBtn.isEnabled = true
            return
        }else if(!Validator.minLength(password: fmale!,length: 2)){
            let alert = UIAlertController(title: "Ошибка", message: "Слишком короткая фамилия", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.saveBtn.isEnabled = true
            return
        }else if(!Validator.nameLiterals(name: fmale!)){
            let alert = UIAlertController(title: "Ошибка", message: "Фамилия должно состоять только из букв", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.saveBtn.isEnabled = true
            return
        }else if(!Validator.validatePhoneNumber(phone: phone!)){
            let alert = UIAlertController(title: "Ошибка", message: "Номер телефона должен быть формата: +375XXYYYYYYY", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.saveBtn.isEnabled = true
            return
        }else{
            sendHashToTheServer(name: name!, fmale: fmale!, phone: phone!)
        }
        
    }
    
    
    
    private func sendHashToTheServer(name:String,fmale:String, phone:String){
        let session = Singleton.currentUser().getUser()?.getProfile()?["session"] as! String
        let dict = ["key":REST_URL.KEY.rawValue,"name":name, "surname":fmale, "phone":phone, "session":session]
        JsonHelperLoad(url: REST_URL.SF_CHANGE_USER_DATA.rawValue, params: dict as Dictionary<String, AnyObject>, act: self, sessionName: "save").startSession()
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
    
    
    func loadComplete(obj: Dictionary<String, AnyObject>?, sessionName: String?) {
        if let status = obj?["status"] as? String{
            if status == "successful" {
                let alert = UIAlertController(title: "Успешно", message: "Данные сохранены", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Ошибка", message: "Соединение с сервером", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            let alert = UIAlertController(title: "Ошибка", message: "Соединение с сервером", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        self.saveBtn.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func scrollViewTapped(recognizer: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private func initViews(){
        
        if let name = Singleton.currentUser().getUser()?.getProfile()?["firstName"] as? String {
            self.name.text = name
        }
        
        if let surname = Singleton.currentUser().getUser()?.getProfile()?["lastName"] as? String {
            self.fmale.text = surname
        }

        if let phone = Singleton.currentUser().getUser()?.getProfile()?["phone"] as? String {
            self.phone.text = "+375\(phone)"
        }
        
        name.delegate = self
        fmale.delegate = self
        phone.delegate = self

        saveBtn.layer.cornerRadius = 5.0
       
        let attributes = [
            NSForegroundColorAttributeName: UIColor.lightGray
        ]
        name.attributedPlaceholder = NSAttributedString(string: "Имя", attributes:attributes)
        fmale.attributedPlaceholder = NSAttributedString(string: "Фамилия", attributes:attributes)
        phone.attributedPlaceholder = NSAttributedString(string: "Номер телефона", attributes:attributes)
        
        name.returnKeyType = UIReturnKeyType.done
        fmale.returnKeyType = UIReturnKeyType.done
        phone.returnKeyType = UIReturnKeyType.done

    }

}
