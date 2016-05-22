//
//  Spot.swift
//  API
//
//  Created by goka on 2016/05/21.
//  Copyright © 2016年 kaneshin.co. All rights reserved.
//

import APIKit
import Himotoki

public struct SpotResponse {
    public var id: Int
    public var visitTime: Int
    public var name: String
    public var photoURL: NSURL
    public var categoryName: String
    public var state: String
    public var city: String
    public var address: String
    public var lat: Double
    public var lng: Double
}

extension SpotResponse : Decodable {
    public static func decode(e: Extractor) throws -> SpotResponse {
        return try SpotResponse(
            id: e <| "id",
            visitTime: e <| "visit_time",
            name: e <| "name",
            photoURL: NSURL(string: e <| "photo_url")!,
            categoryName: e <| "category_name",
            state: e <| "state",
            city: e <| "city",
            address: e <| "address",
            lat: e <| "lat",
            lng: e <| "lng"
        )
    }
}

public struct SpotLog {
    public var visitTime: Int
    public var lat: Double
    public var lng: Double
    public init(t: Int, lat: Double, lng: Double) {
        self.visitTime = t
        self.lat = lat
        self.lng = lng
    }
}

public struct CreateSpotRequest: BreakRequestType {
    
    public typealias Response = [String: AnyObject]
    
    var params: [String: AnyObject] = [:]
    
    public init(spotLogs: [SpotLog]) {
        var logs: [AnyObject] = []
        for log in spotLogs {
            var l: [String: AnyObject] = [:]
            l["visit_time"] = log.visitTime
            l["lat"] = log.lat
            l["lng"] = log.lng
            logs.append(l)
        }
        params["spot_logs"] = logs
    }
    
    public var method: HTTPMethod {
        return .POST
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
        return [:]
    }
}

public struct GetSpotRequest: BreakRequestType {
    
    public typealias Response = [SpotResponse]
    
    var params: [String: AnyObject] = [:]
    
    public init() {}

    public mutating func setVisitRange(startVisitTime:Int, endVisitTime:Int) {
        params["start_visit_time"] = startVisitTime
        params["end_visit_time"] = endVisitTime
    }
    
    public mutating func setTourID(tourID:Int) {
        params["tour_id"] = tourID
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
        var response: [SpotResponse] = []
        for instance in instances {
            if let ins = instance as? [String: AnyObject] {
                let ret: SpotResponse = try! decodeValue(ins)
                response.append(ret)
            }
        }
        return response
    }
}
