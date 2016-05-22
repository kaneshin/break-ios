// SearchController.swift
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

class TourDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //let tracker: Tracker = Tracker()

    var tour: TourResponse!
    var spots: [SpotResponse] = []

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
        // tableView.sectionHeaderHeight = 200

        self.spots = Sample().SpotResponseWithTourID(tour.id)

        let now = NSDate().timeIntervalSince1970

        var req: GetSpotRequest = GetSpotRequest()
        req.setVisitRange(Int(now) - 100000, endVisitTime: Int(now) + 100000)
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

        return

        var request: GetSpotRequest = GetSpotRequest()
        request.setTourID(tour.id)
        Session.sendRequest(request) { response in
            switch response {
            case .Success(let response):
                self.spots = response
                self.tableView.reloadData()
                break
            case .Failure(let error):
                print(error)
                break
            }
        }
    }


    // MARK: - Table View

//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableCellWithIdentifier(TourListCell.identifier)
//        if let cell = cell as? TourListCell {
//            let realm = try! Realm()
//            let meEntity = MeEntity()
//            if let user = realm.objects(UserEntity).filter("id = \(meEntity.id)").last {
//                let userImageURL: NSURL = NSURL(fileURLWithPath: (user.photoURL))
//                cell.userImageView.setImageWithURL(userImageURL, placeholderImage: nil, completionHandler:nil)
//            }
//            cell.userImageView.setImageWithURL(NSURL(fileURLWithPath: "https://scontent.xx.fbcdn.net/v/t1.0-1/p200x200/10959521_615826671880723_1191735095536536476_n.jpg?oh=5e84e1e18c0c699a59ebeaf1d0d9651e&oe=57CE5D42"), placeholderImage: nil, completionHandler:nil)
//        }
//        return cell
//    }
//

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.spots.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return TourListCell.heightForRow
        }
        return TourItemCell.heightForRow
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            if indexPath.section == 0 {
                return tableView.dequeueReusableCellWithIdentifier(TourListCell.identifier, forIndexPath: indexPath)
            }
            return tableView.dequeueReusableCellWithIdentifier(TourItemCell.identifier, forIndexPath: indexPath)
        }()
        if let cell = cell as? TourListCell {
            if indexPath.section == 0 {
                let imageURL: NSURL = tour.photoURL
                let userImageURL: NSURL = tour.user.photoURL
                cell.mainImageView.setImageWithURL(imageURL)
                cell.userImageView.setImageWithURL(userImageURL)
                cell.titleTextField.text = tour.name
//                cell.dateLabel.text = "\(tour.takenHour) Hours"
                cell.date(Double(tour.takenHour))
                cell.likeCountLabel.text = "\(rand() % 200)"
            }
        } else if let cell = cell as? TourItemCell {
            if indexPath.section == 1 {
                let spot = self.spots[indexPath.row]
                cell.detailLabel.text = spot.name
                let date = NSDate(timeIntervalSince1970: Double(spot.visitTime))
                let formatter = NSDateFormatter()
                formatter.dateFormat = "HH:mm"
                let dateStr: String = formatter.stringFromDate(date)
                cell.dateLabel.text = dateStr
            }
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

}

