//
//  LoginController.swift
//  break
//
//  Created by goka on 2016/05/21.
//  Copyright © 2016年 kaneshin.co. All rights reserved.
//

import UIKit
import API
import Auth
import APIKit

class LoginController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loginBreak(name:String, email:String, photoURL:String) {
        let request : LoginMeRequest = LoginMeRequest(name: name, email: email, photoURL:photoURL)
        Session.sendRequest(request) { response in
            switch response {
            case .Success(let meResponse):
                print(meResponse)
                // TODO push to next controller.
                break
            case .Failure(let error):
                print(error)
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fbLogin : FacebookLogin = FacebookLogin()
        fbLogin.loginCallback = { (name:String, email:String, photoURL:String) -> Void in
            self.loginBreak(name, email: email, photoURL: photoURL)
        }
        self.view.addSubview(fbLogin.loginButton)
        fbLogin.loginButton.center = self.view.center
        fbLogin.delegate()
    }
    
}

