//
//  BonusViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/16/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class BonusViewController: BaseViewController, UITextFieldDelegate, LoadJson{
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    private var textFieldActive:UITextField?
    
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
        let email = self.email.text?.trim()
        saveBtn.isEnabled = false
        if(!Validator.email(email: email!)){
            let alert = UIAlertController(title: "Ошибка", message: "Не верный формат email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.saveBtn.isEnabled = true
            return
        }else{
            sendHashToTheServer(email: email!)
        }

    }
    
    private func sendHashToTheServer(email:String){
        let session = Singleton.currentUser().getUser()?.getProfile()?["session"] as! String
        let dict = ["key":REST_URL.KEY.rawValue,"email":email, "session": session]
        JsonHelperLoad(url: REST_URL.SF_INVIREMENT.rawValue, params: dict as Dictionary<String, AnyObject>, act: self, sessionName: "invite").startSession()
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

        if let status = obj?["status"] as? String {
            if status == "successful" {
                let alert = UIAlertController(title: "Успешно", message: "Вашему другу отправлено приглошение", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Ошибка", message: obj?["message"] as? String, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            self.email.text = ""
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
        
        email.delegate = self
        saveBtn.layer.cornerRadius = 5.0
        let attributes = [NSForegroundColorAttributeName: UIColor.lightGray]
        email.attributedPlaceholder = NSAttributedString(string: "Email", attributes:attributes)
        email.returnKeyType = UIReturnKeyType.done
        email.keyboardType = .emailAddress

    }
}
