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

class LoginController: UIViewController, UIScrollViewDelegate {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func pushToTourSearchController() {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TourSearchController")
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func login(name:String, email:String, photoURL:String) {
        let request : LoginMeRequest = LoginMeRequest(name: name, email: email, photoURL:photoURL)
        Session.sendRequest(request) { response in
            switch response {
            case .Success(let meResponse):
                let realm = try! Realm()
                let id = meResponse.id
                if let user = realm.objects(UserEntity).filter("id = %d", id).first {
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
                me.token = meResponse.token
                self.dismissViewControllerAnimated(true, completion: nil)
                self.pushToTourSearchController()
                break
            case .Failure(let error):
                print(error)
                break
            }
        }
    }
    
    let fb : FacebookLogin = FacebookLogin()
    
    @IBOutlet weak var fbLoginView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fb.loginCallback = {(name:String, email:String, photoURL:String) -> Void in
            self.login(name, email: email, photoURL: photoURL)
        }
        fb.loginIfHasAccessToken()
        let gesture = UITapGestureRecognizer(target:self, action: #selector(LoginController.didClickFBLoginView(_:)))
        fbLoginView.addGestureRecognizer(gesture)
    }
    
    func didClickFBLoginView(recognizer: UIGestureRecognizer) {
        fb.initiate(self)
    }
}

