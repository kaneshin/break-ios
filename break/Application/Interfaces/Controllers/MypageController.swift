// MypageController.swift
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
import RealmSwift
import API

class MypageController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var tours: [TourResponse] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        let me = MeEntity()
        if let user = realm.objects(UserEntity).filter("id = %d", me.id).first {
            if let url = NSURL(string: user.photoURL) {
                print(url)
                self.imageView.setImageWithURL(url)
            }
            self.nameLabel.text = user.name
        }

        tableView.registerNib(TourListCell.nib, forCellReuseIdentifier: TourListCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self

        let tour: TourResponse = Sample().TourResponse(1)
        for _ in 0...10 {
            self.tours.append(tour)
        }

        return
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
            })
            cell.titleTextField.text = tour.name
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
