//
//  LoginController.swift
//  Auth
//
//  Created by goka on 2016/05/21.
//  Copyright © 2016年 kaneshin.co. All rights reserved.
//

import UIKit

import FBSDKCoreKit
import FBSDKLoginKit

public class FacebookLogin: NSObject, FBSDKLoginButtonDelegate {
    
    public var loginCallback:((String, String, String)->Void)?
    
    public let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["public_profile", "email"]
        return button
    }()
    
    public func delegate() {
        loginButton.delegate = self
        if let _ = FBSDKAccessToken.currentAccessToken() {
            fetchProfile()
        }
    }
    
    public func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        fetchProfile()
    }
    
    public func fetchProfile() {
        let parameters = ["fields": "email, name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler({ (connection, user, requestError) -> Void in
            if requestError != nil {
                print(requestError)
                return
            }
            let name = user["name"] as? String
            let email = user["email"] as? String
            var pictureURL = ""
            if let picture = user["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary, url = data["url"] as? String {
                pictureURL = url
            }
            self.loginCallback!(name!, email!, pictureURL)
        })
    }
    
    public func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }
    
    public func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
}
