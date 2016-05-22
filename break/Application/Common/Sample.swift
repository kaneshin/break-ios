// Sample.swift
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

import API
import RealmSwift
import Himotoki

class Sample {

    let me = MeEntity()

    func TourResponse(id: Int) -> API.TourResponse {
        return DeNangTourResponse()
    }

    func DeNangTourResponse() -> API.TourResponse {

        var dat: [String: AnyObject] = [:]
        dat["id"] = 3
        dat["name"] = "Awesome De Nang!"
        dat["photo_url"] = "http://s32.postimg.org/g3wjwlu7p/12665830_1015751411819209_1013964377_n.jpg"
        dat["taken_hour"] = 31.0

        let realm = try! Realm()
        if let user = realm.objects(UserEntity).filter("id = %d", me.id).last {
            var udat: [String: AnyObject] = [:]
            udat["id"] = user.id
            udat["name"] = user.name
            udat["photo_url"] = user.photoURL
            dat["user"] = udat
        }
        return try! decodeValue(dat)
    }

    func SpotResponseWithTourID(tourID: Int) -> [API.SpotResponse] {
        return []
    }


}
