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

class TourCreateController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tracker: Tracker = Tracker()

    enum Section: Int {
        case List
        case Item
        case Unknown
        var identifier: String {
            switch self {
            case .List:
                return "TourListCell"
            case .Item:
                return "TourItemCell"
            default:
                return "Cell"
            }
        }
    }

    @IBOutlet weak var tableView: UITableView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(TourListCell.nib, forCellReuseIdentifier: TourListCell.identifier)
        tableView.registerNib(TourItemCell.nib, forCellReuseIdentifier: TourItemCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self

        // tracker.stopUpdatingLocation()
        let me = MeEntity()
        let now = NSDate().timeIntervalSince1970
        let records: [Location] = tracker.find(me.lastRecordTime, to: now, limit: 5)

        var logs: [SpotLog] = []
        for record in records {
            let log: SpotLog = SpotLog(t: Int(record.recordTime), lat: record.latitude, lng: record.longitude)
            logs.append(log)
        }

        let request: CreateSpotRequest = CreateSpotRequest(spotLogs: logs)
        Session.sendRequest(request) { response in
            switch response {
            case .Success( _):
//                me.lastRecordTime = now
//                me.save()
                var req: GetSpotRequest = GetSpotRequest()
                req.setVisitRange(Int(me.lastRecordTime), endVisitTime: Int(now))
                Session.sendRequest(req) { response in
                    switch response {
                    case .Success(let response):
                        print(response)
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

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Section.Unknown.rawValue
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sec: Section = Section.init(rawValue: section)!
        switch sec {
        case .Item:
            return 100
        default:
            return 1
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let sec: Section = Section.init(rawValue: indexPath.section)!
        switch sec {
        case .Item:
            return TourItemCell.heightForRow
        default:
            return TourListCell.heightForRow
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            let sec: Section = Section.init(rawValue: indexPath.section)!
            return tableView.dequeueReusableCellWithIdentifier(sec.identifier, forIndexPath: indexPath)
        }()
        if let cell = cell as? TourListCell {
            cell.editable = true
            cell.hideLikeView = true
            let from: NSDate = NSDate().dateByAddingTimeInterval(-10000)
            let imageURL: NSURL = NSURL(string: "http://placehold.it/\(rand()%1000)x\(rand()%1000)")!
            let userImageURL: NSURL = NSURL(string: "https://avatars2.githubusercontent.com/u/1888355?v=3&s=400")!
            cell.mainImageView.setImageWithURL(imageURL)
            cell.userImageView.setImageWithURL(userImageURL)
            cell.titleTextField.text = "Tap to rename"
            cell.date(from, to: NSDate())
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
