// CreateTourController.swift
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

import UIKit
import Location
import API
import APIKit
import RealmSwift

class TourCreateController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //let tracker: Tracker = Tracker()

    var spots: [SpotResponse] = []
    
    
    @IBOutlet weak var tableView: UITableView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(TourItemCell.nib, forCellReuseIdentifier: TourItemCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = TourListCell.heightForRow
        
        // tracker.stopUpdatingLocation()
        let now = NSDate().timeIntervalSince1970
        //let records: [Location] = tracker.find(me.lastRecordTime, to: now, limit: 5)

        var logs: [SpotLog] = []
        //for record in records {
            // let log: SpotLog = SpotLog(t: Int(record.recordTime), lat: record.latitude, lng: record.longitude)
            // logs.append(log)
        //}
        //35.66938789010993,139.7162959157403
        let currentSpotLog = SpotLog(t: Int(now), lat: 35.66938789010993, lng: 139.7162959157403)
        logs.append(currentSpotLog)
        
        let request: CreateSpotRequest = CreateSpotRequest(spotLogs: logs)
        Session.sendRequest(request) { response in
            switch response {
            case .Success( _):
                var req: GetSpotRequest = GetSpotRequest()
                req.setVisitRange(Int(now) - 10, endVisitTime: Int(now) + 10)
                Session.sendRequest(req) { response in
                    switch response {
                    case .Success(let response):
                        print(response)
                        self.spots = response
                        self.tableView.reloadData()
                        break
                    case .Failure(let error):
                        print(error)
                        break
                    }
                }
                break
            case .Failure(let error):
                print(error)
                break
            }
        }
    }


    // MARK: - Table View
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell:TourListCell = UINib(nibName: TourListCell.identifier, bundle: nil).instantiateWithOwner(self, options: nil)[0] as! TourListCell
        cell.userImageView.image = nil;
        cell.editable = true
        cell.hideLikeView = true
        cell.mainImageView.backgroundColor = UIColor.lightGrayColor()
        cell.likeActionButton.hidden = true
        let me = MeEntity()
        let realm = try! Realm()
        if let user = realm.objects(UserEntity).filter("id = %d", me.id).last {
            let data = NSData(contentsOfURL: NSURL(string: user.photoURL)!)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                let image = UIImage(data: data!)
                dispatch_async(dispatch_get_main_queue()) {
                    cell.userImageView.image = image;
                }
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.spots.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TourItemCell.heightForRow
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            return tableView.dequeueReusableCellWithIdentifier(TourItemCell.identifier, forIndexPath: indexPath)
        }()
        if let cell = cell as? TourItemCell {
            let spot = self.spots[indexPath.row]
            cell.detailLabel.text = spot.name
            let date = NSDate(timeIntervalSince1970: Double(spot.visitTime))
            let formatter = NSDateFormatter()
            formatter.dateFormat = "HH:mm"
            let dateStr: String = formatter.stringFromDate(date)
            cell.dateLabel.text = dateStr
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
