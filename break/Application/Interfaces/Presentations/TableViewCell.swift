// TableViewCell.swift
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

class TableViewCell: UITableViewCell {

}

class TourListCell: TableViewCell, UITextFieldDelegate {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeActionButton: UIButton!

    static let identifier: String = "TourListCell"
    static let nib = UINib.init(nibName: identifier, bundle: nil)
    static let heightForRow: CGFloat = 280.0

    var editable: Bool = false {
        didSet {
            titleTextField.enabled = editable
        }
    }

    var hideLikeView: Bool = false {
        didSet {
            likeCountLabel.hidden = hideLikeView
            likeImageView.hidden = hideLikeView
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextField.delegate = self
        self.editable = false
        self.hideLikeView = false
        self.reset()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.reset()
    }

    func reset() {
        mainImageView.image = nil
        userImageView.image = nil
        titleTextField.text = ""
        dateLabel.text = ""
        likeCountLabel.text = ""
    }

    func date(from: NSDate, to: NSDate) {
        self.dateLabel.text = from.string(.TourList, to: to)
    }

    var edited: Bool = false

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if !edited {
            textField.text = ""
        }
        return true
    }

    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            edited = false
            textField.text = "Tap to rename"
        }
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        edited = true
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func resignFirstResponder() -> Bool {
        return titleTextField.resignFirstResponder()
    }

}

class TourItemCell: TableViewCell {

    static let identifier: String = "TourItemCell"
    static let nib = UINib.init(nibName: identifier, bundle: nil)
    static let heightForRow: CGFloat = 108.0

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lineImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.reset()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.reset()
    }

    func reset() {
        dateLabel.text = ""
        detailLabel.text = ""
    }

}


