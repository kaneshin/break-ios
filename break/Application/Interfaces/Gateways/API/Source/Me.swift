//
//  Me.swift
//  API
//
//  Created by goka on 2016/05/21.
//  Copyright © 2016年 kaneshin.co. All rights reserved.
//

import APIKit
import Himotoki

public struct MeResponse {
    public var id: Int
    public var name: String
    public var photoURL: NSURL
    public var token: String
}

extension MeResponse : Decodable {
    public static func decode(e: Extractor) throws -> MeResponse {
        return try MeResponse(
            id: e <| "id",
            name: e <| "name",
            photoURL: NSURL(string: e <| "photo_url")!,
            token: e <| "token"
        )
    }
}

public struct LoginMeRequest: BreakRequestType {
    
    public typealias Response = MeResponse
    
    var params: [String: AnyObject] = [:]
    
    public init(name:String, email:String, photoURL:String) {
        params["name"] = name
        params["email"] = email
        params["photo_url"] = photoURL
    }
    
    public var method: HTTPMethod {
        return .POST
    }
    
    public var path: String {
        return "/me/login"
    }
    
    public var parameters: [String: AnyObject] {
        return params
    }
    
    public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        print(object)
        return try? decodeValue(object["instance"] as! [String:AnyObject])
    }
}

public struct GetMeRequest: BreakRequestType {
    
    public typealias Response = MeResponse
    
    var params: [String: AnyObject] = [:]
    
    public init() {
    }
    
    public var method: HTTPMethod {
        return .GET
    }
    
    public var path: String {
        return "/me"
    }
    
    public var parameters: [String: AnyObject] {
        return params
    }
    
    public func configureURLRequest(URLRequest: NSMutableURLRequest) throws -> NSMutableURLRequest {
        let ud = NSUserDefaults.standardUserDefaults()
        if let token : AnyObject! = ud.objectForKey("token") {
            let accessToken = token as! String
            URLRequest.setValue("AccessToken \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        return URLRequest
    }
    
    public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        print(object)
        return try? decodeValue(object["instance"] as! [String:AnyObject])
    }
}
