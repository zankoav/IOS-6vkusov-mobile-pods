//
//  ProfileViewHeader.swift
//  6vkusov-mobile
//
//  Created by Alexandr Zanko on 6/15/17.
//  Copyright © 2017 Alexandr Zanko. All rights reserved.
//

import UIKit

@IBDesignable class ProfileViewHeader: UIView, LoadJson{
    
    var view: UIView!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var callFriendsBtn: UIButton!
    @IBOutlet weak var bonus: UILabel!
    
    var controller: ProfileViewController?

    var attrs = [
        NSFontAttributeName : UIFont.systemFont(ofSize: 12.0),
        NSForegroundColorAttributeName : UIColor.white,
        NSUnderlineStyleAttributeName : 1] as [String : Any]
    
    var attributedString = NSMutableAttributedString(string:"")
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func loadComplete(obj: Dictionary<String, AnyObject>?, sessionName: String?) {
        if let json = obj {
            if let points = json["points"] as? Int {
                Singleton.currentUser().getUser()?.setPoints(points: points)
                self.bonus.text = "\(points) баллов "
                self.bonus.isHidden = false
            }
        }
    }
    
    private func commonInit()
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ProfileViewHeader", bundle: bundle)
        self.view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.icon.layer.cornerRadius = self.icon.bounds.width/2
        self.icon.clipsToBounds = true
        self.icon.layer.borderWidth = 2.0
        self.icon.layer.borderColor = UIColor.white.cgColor
        self.bonus.layer.masksToBounds = true
        self.bonus.layer.cornerRadius = 5
        self.bonus.isHidden = true
        var dict = Dictionary<String,AnyObject>()
        dict["key"] = REST_URL.KEY.rawValue as AnyObject
        dict["session"] = Singleton.currentUser().getUser()?.getProfile()?["session"] as AnyObject
        JsonHelperLoad.init(url: REST_URL.SF_GET_USER_POINTS.rawValue, params: dict, act: self, sessionName: nil).startSession()
        
        let changeBtnStr = NSMutableAttributedString(string:"Редактировать", attributes:attrs)
        let callFriendsBtnStr = NSMutableAttributedString(string:"Позвать друга", attributes:attrs)
        
        attributedString.append(changeBtnStr)
        changeBtn.setAttributedTitle(attributedString, for: .normal)
        
        attributedString = NSMutableAttributedString(string:"")
        attributedString.append(callFriendsBtnStr)
        
        callFriendsBtn.setAttributedTitle(attributedString, for: .normal)
        
        self.addSubview(self.view)
    }
    
    @IBAction func clickCallFriends(_ sender: Any) {
        if self.controller != nil {
            self.controller?.clickCallFriends()
        }
    }
    
    @IBAction func clickSettingsChange(_ sender: Any){
        if self.controller != nil {
            self.controller?.clickSettingsChange()
        }
    }
    
    
}
