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
import RealmSwift

class LoginController: UIViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func loginBreak(name:String, email:String, photoURL:String) {
        let request : LoginMeRequest = LoginMeRequest(name: name, email: email, photoURL:photoURL)
        Session.sendRequest(request) { response in
            switch response {
            case .Success(let meResponse):
                let realm = try! Realm()
                let id = meResponse.id
                if let user = realm.objects(UserEntity).filter("id = \(id)").first {
                    try! realm.write {
                        user.name = meResponse.name
                        user.photoURL = meResponse.photoURL.absoluteString
                    }
                } else {
                    try! realm.write {
                        let user: UserEntity = UserEntity()
                        user.id = id
                        user.name = meResponse.name
                        // user.email = meResponse.email
                        user.photoURL = meResponse.photoURL.absoluteString
                        realm.add(user)
                    }
                }
                let me = MeEntity()
                me.id = id
                me.token = meResponse.token
                self.dismissViewControllerAnimated(true, completion: nil)
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

