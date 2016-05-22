// Location.swift
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
import CoreLocation
import RealmSwift

public class Location: Object {
    public dynamic var latitude: Double = 0.0
    public dynamic var longitude: Double = 0.0
    public dynamic var speed: Double = 0.0
    public dynamic var recordTime: Double = NSDate().timeIntervalSince1970
}

public class Tracker: NSObject, CLLocationManagerDelegate {

    var manager: CLLocationManager?

    public override init() {
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            manager = CLLocationManager()
            manager!.delegate = self
            if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
                manager!.requestAlwaysAuthorization()
            }
        }
    }

    public func startUpdatingLocation() {
        guard let manager = manager else {
            return
        }
        manager.startUpdatingLocation()
    }

    public func stopUpdatingLocation() {
        guard let manager = manager else {
            return
        }
        manager.stopUpdatingLocation()
    }

    // MARK: - CLLocationManager delegate

    public func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined:
            break
        case .Restricted, .Denied:
            break
        case .Authorized, .AuthorizedWhenInUse:
            break
        }
    }

    public func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        let coordinate = newLocation.coordinate
        let realm = try! Realm()
        try! realm.write {
            let loc: Location = Location()
            loc.latitude = coordinate.latitude
            loc.longitude = coordinate.longitude
            loc.speed = Double(newLocation.speed)
            realm.add(loc)
        }
    }

    public func find(from: Double, to: Double, limit: Int) -> [Location] {
        let realm = try! Realm()
        let results = realm.objects(Location).filter("%f < recordTime AND recordTime < %f", from, to)
        let count = results.count
        if count < limit {
            return Array(results)
        }
        let p = count / limit
        var array: [Location] = []
        var i = 0
        for result in results {
            if i % p == 0 {
                array.append(result)
            }
            i += 1
        }
        return array
    }

    public func findLatest() -> Location? {
        let realm = try! Realm()
        return realm.objects(Location).sorted("recordTime", ascending: false).first
    }
}
