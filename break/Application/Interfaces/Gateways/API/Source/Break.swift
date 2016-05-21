// Break.swift
//
// Copyright (c) 2016 kaneshin.co
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import APIKit
import Himotoki

public protocol BreakRequestType : RequestType {
}

extension BreakRequestType {
    public var baseURL:NSURL {
        return NSURL(string: "http://localhost:8888/api")!
    }
}

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
        return try? decodeValue(object["instance"] as! [String:AnyObject])
    }
}




