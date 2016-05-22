// UserEntity.swift
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

import Foundation
import RealmSwift

class MeEntity {

    let defaults = NSUserDefaults.standardUserDefaults()

    var token: String {
        set {
            defaults.setObject(newValue, forKey: "me.token")
            defaults.setObject(newValue, forKey: "token")
        }
        get {
            if let token = defaults.objectForKey("me.token") as? String {
                return token
            }
            return ""
        }
    }

    var id: Int {
        set {
            defaults.setObject(newValue, forKey: "me.id")
        }
        get {
            if let id = defaults.objectForKey("me.id") as? Int {
                return id
            }
            return 0
        }
    }

    var lastRecordTime: NSTimeInterval {
        set {
            defaults.setObject(newValue, forKey: "me.last_record_time")
        }
        get {
            if let recordTime = defaults.objectForKey("me.last_record_time") as? NSTimeInterval {
                return recordTime
            }
            return 0.0
        }
    }

    func save() -> Bool {
        return defaults.synchronize()
    }
}

class UserEntity: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var email: String = ""
    dynamic var photoURL: String = ""
    dynamic var activeStatus: Bool = false
    // dynamic var token: String = ""
    dynamic var dynamic: NSDate = NSDate()
}
