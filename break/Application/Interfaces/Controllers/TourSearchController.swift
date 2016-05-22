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

class TourSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    let tracker = Location.Tracker()

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
    }

    override func viewWillAppear(animated: Bool) {
        let me = MeEntity()
        if me.token != "" {
            tracker.startUpdatingLocation()
        }
    }

    // MARK: - Table View

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return TourListCell.heightForRow
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TourListCell", forIndexPath: indexPath)
        if let cell = cell as? TourListCell {
            let from: NSDate = NSDate().dateByAddingTimeInterval(-10000)
            let imageURL: NSURL = NSURL(string: "http://placehold.it/\(rand()%1000)x\(rand()%1000)")!
            let userImageURL: NSURL = NSURL(string: "https://avatars2.githubusercontent.com/u/1888355?v=3&s=400")!
            cell.mainImageView.setImageWithURL(imageURL)
            cell.userImageView.setImageWithURL(userImageURL, placeholderImage: nil, completionHandler: { (image, error) in
                /*
                cell.userImageView.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.1, 0.1), 800.0)
                UIView.animateWithDuration(1.2,
                    delay: 0.2,
                    usingSpringWithDamping: 0.2,
                    initialSpringVelocity: 6.0,
                    options: UIViewAnimationOptions.AllowUserInteraction,
                    animations: {
                        cell.userImageView.transform = CGAffineTransformIdentity
                    }, completion: nil)
                 */
            })
            cell.titleTextField.text = "山下です。こんばんは。"
            cell.date(from, to: NSDate())
            cell.likeCountLabel.text = "\(rand())"
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("TourDetailController")
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
