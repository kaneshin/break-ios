//
//  Tour.swift
//  API
//
//  Created by goka on 2016/05/22.
//  Copyright © 2016年 kaneshin.co. All rights reserved.
//

import APIKit
import Himotoki

public struct UserResponse {
    public var id: Int
    public var name: String
    public var photoURL: NSURL
}

extension UserResponse : Decodable {
    public static func decode(e: Extractor) throws -> UserResponse {
        return try UserResponse(
            id: e <| "id",
            name: e <| "name",
            photoURL: NSURL(string: e <| "photo_url")!
        )
    }
}

public struct TourResponse {
    public var id: Int
    public var name: String
    public var photoURL: NSURL
    public var takenHour:Float
    public var user: UserResponse
}

extension TourResponse : Decodable {
    public static func decode(e: Extractor) throws -> TourResponse {
        return try TourResponse(
            id: e <| "id",
            name: e <| "name",
            photoURL: NSURL(string: e <| "photo_url")!,
            takenHour: e <| "taken_hour",
            user: e <| "user"
        )
    }
}


public struct CreateTourRequest: BreakRequestType {
    
    public typealias Response = [String: AnyObject]
    
    var params: [String: AnyObject] = [:]
    
    public init(name:String, photoURL:String, spotIDs:[Int]) {
        params["name"] = name
        params["photo_url"] = photoURL
        params["spot_ids"] = spotIDs
    }
    
    public var method: HTTPMethod {
        return .POST
    }
    
    public var path: String {
        return "/tour"
    }
    
    public var parameters: [String: Any] {
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
        return [:]
    }
}

public struct GetTourRequest: BreakRequestType {
    
    public typealias Response = [TourResponse]
    
    var params: [String: AnyObject] = [:]
    
    public init() {}
    
    public mutating func setLatLng(lat:Double, lng:Double) {
        params["lat"] = lat
        params["lng"] = lng
    }
    
    public mutating func setUserID(userID:Int) {
        params["user_id"] = userID
    }
    
    public var method: HTTPMethod {
        return .GET
    }
    
    public var path: String {
        return "/spot"
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
        guard let instances = object["instances"] as? [AnyObject] else {
            return nil
        }
        var response: [TourResponse] = []
        for instance in instances {
            if let ins = instance as? [String: AnyObject] {
                let ret: TourResponse = try! decodeValue(ins)
                response.append(ret)
            }
        }
        return response
    }

}
