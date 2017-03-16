//
//  BonusViewController.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 3/16/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

class BonusViewController: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var friendAddress: UITextField!
    @IBOutlet weak var callButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.title = "Получить бонусы"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributes = [
            NSForegroundColorAttributeName: UIColor.lightGray
        ]
        friendAddress.delegate = self
        friendAddress.attributedPlaceholder = NSAttributedString(string: "Email", attributes:attributes)
        friendAddress.returnKeyType = UIReturnKeyType.done
        
        callButton.layer.masksToBounds = true
        callButton.layer.cornerRadius = 5
        let theTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        self.view.addGestureRecognizer(theTap)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func scrollViewTapped(recognizer: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        let email = self.friendAddress.text
        //        callFriendButton.isEnabled = false
        if(!Validator.email(email: email!)){
            alertShow(textError: "Не верный формат email")
            callButton.isEnabled = true
            return
        }else{
            print("send \(email)")
        }

        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
