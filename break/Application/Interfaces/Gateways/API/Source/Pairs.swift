// Pairs.swift
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

public protocol PairsRequestType : RequestType {
}

extension PairsRequestType {
    public var baseURL:NSURL {
        return NSURL(string: "https://pairs.lv/1.0")!
    }
}

public struct WelcomeData {
    public var defaultGender: String = ""
    public var defaultMainImageURL: String = ""
    public var defaultNickname: String = ""
    public var defaultResidenceCountryID: Int = 0
    public var defaultResidenceStateID: Int = 0
    public var newUser: Int = 0
}

extension WelcomeData {
    public init?(dictionary: [String: AnyObject]) {
        guard let gender = dictionary["default_gender"] as? String else {
            return nil
        }
        guard let mainImageURL = dictionary["default_main_image_url"] as? String else {
            return nil
        }
        guard let nickname = dictionary["default_nickname"] as? String else {
            return nil
        }
        guard let residenceCountryID = dictionary["default_residence_country_id"] as? Int else {
            return nil
        }
        guard let residenceStateID = dictionary["default_residence_state_id"] as? Int else {
            return nil
        }
        guard let newUser = dictionary["new_user"] as? Int else {
            return nil
        }

        self.defaultGender = gender
        self.defaultMainImageURL = mainImageURL
        self.defaultNickname = nickname
        self.defaultResidenceCountryID = residenceCountryID
        self.defaultResidenceStateID = residenceStateID
        self.newUser = newUser
    }
}

public struct GETWelcomeRequest: PairsRequestType {

    public typealias Response = WelcomeData

    public var method: HTTPMethod {
        return .GET
    }

    public var path: String {
        return "/me/welcome"
    }

    public var parameters: [String: AnyObject] {
        var result: [String: AnyObject] = [:]
        result["device"] = "pc"
        return result
    }

    public init() {}

    public func responseFromObject(object: AnyObject, URLResponse: NSHTTPURLResponse) -> Response? {
        guard let dictionary = object as? [String: AnyObject] else {
            return nil
        }

        guard let welcomeData = WelcomeData(dictionary: dictionary) else {
            return nil
        }

        return welcomeData
    }
}


