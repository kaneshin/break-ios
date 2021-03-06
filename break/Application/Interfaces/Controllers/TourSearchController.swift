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
import Himotoki

class TourSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let tracker: Tracker = Tracker()
    var tours: [TourResponse] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(TourListCell.nib, forCellReuseIdentifier: TourListCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        let me = MeEntity()
        if me.token == "" {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginController")
            let delay = 0.5 * Double(NSEC_PER_SEC)
            let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue(), {
                self.presentViewController(controller, animated: true, completion: nil)
            })
        }

        return
        guard let loc = tracker.findLatest() else {
            return
        }
        var request: GetTourRequest = GetTourRequest()
        request.setLatLng(loc.latitude, lng: loc.longitude)
        Session.sendRequest(request) { response in
            switch response {
            case .Success(let response):
                self.tours = response
                self.tableView.reloadData()
                break
            case .Failure(let error):
                print(error)
                break
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
        let me = MeEntity()
        if me.token != "" {
            let tour: TourResponse = Sample().TourResponse(1)
            self.tours = [tour]
            tracker.startUpdatingLocation()
        }
    }

    // MARK: - Table View

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tours.count
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TourListCell.heightForRow
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        if self.tours.count <= row {
            return UITableViewCell()
        }
        let tour = self.tours[row]
        let cell = tableView.dequeueReusableCellWithIdentifier("TourListCell", forIndexPath: indexPath)
        if let cell = cell as? TourListCell {
            let imageURL: NSURL = tour.photoURL
            let userImageURL: NSURL = tour.user.photoURL
            cell.mainImageView.setImageWithURL(imageURL)
            cell.userImageView.setImageWithURL(userImageURL, placeholderImage: nil, completionHandler: { (image, error) in
//                cell.userImageView.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.1, 0.1), 800.0)
//                UIView.animateWithDuration(2.0,
//                    delay: 0.2,
//                    usingSpringWithDamping: 0.2,
//                    initialSpringVelocity: 11.0,
//                    options: UIViewAnimationOptions.AllowUserInteraction,
//                    animations: {
//                        cell.userImageView.transform = CGAffineTransformIdentity
//                    }, completion: nil)
            })
            cell.titleTextField.text = tour.name
            // let from: NSDate = NSDate().dateByAddingTimeInterval(-10000)
            // cell.date(from, to: NSDate())
            cell.date(Double(tour.takenHour))
            cell.likeCountLabel.text = "\(rand() % 200)"
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        if self.tours.count <= row {
            return
        }
        let tour = self.tours[row]
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TourDetailController")
        if let c = controller as? TourDetailController {
            c.tour = tour
            c.navigationItem.title = tour.name
        }
        self.navigationController?.pushViewController(controller, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
