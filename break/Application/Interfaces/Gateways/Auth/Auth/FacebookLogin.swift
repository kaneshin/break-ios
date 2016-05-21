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

public class FacebookLogin {
    
    public var loginCallback:((String, String, String)->Void)?
    
    public init() {}
    
    public func loginIfHasAccessToken() {
        if let _ = FBSDKAccessToken.currentAccessToken() {
            login()
        }
    }
    
    func login() {
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
            print(user)
            self.loginCallback!(name!, email!, pictureURL)
        })
    }
    
    public func initiate(fromViewController:UIViewController) {
        let loginManager = FBSDKLoginManager()
        loginManager.logInWithReadPermissions(["public_profile", "email"], fromViewController:fromViewController, handler: {(result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if (error != nil) {
                self.removeFacebookData()
            } else if result.isCancelled {
                self.removeFacebookData()
            } else {
                if result.grantedPermissions.contains("email") && result.grantedPermissions.contains("public_profile") {
                    self.login()
                }
            }
        })
    }
    
    func removeFacebookData() {
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
    }
    
}
