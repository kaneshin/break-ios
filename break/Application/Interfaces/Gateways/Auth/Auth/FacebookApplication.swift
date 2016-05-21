//
//  Auth.swift
//  Auth
//
//  Created by goka on 2016/05/21.
//  Copyright © 2016年 kaneshin.co. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit

public class FacebookApplication {
    
    public init() {}
    
    public func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application,openURL: url,sourceApplication: sourceApplication,annotation: annotation)
    }
    
    public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
