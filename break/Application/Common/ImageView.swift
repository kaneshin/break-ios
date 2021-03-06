// Button.swift
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
import Kingfisher

extension UIImageView {
    func setImageWithURL(URL: NSURL) {
        self.setImageWithURL(URL, placeholderImage: nil, completionHandler: nil)
    }

    func setImageWithURL(URL: NSURL, placeholderImage: UIImage?) {
        self.setImageWithURL(URL, placeholderImage: placeholderImage, completionHandler: nil)
    }

    func setImageWithURL(URL: NSURL, placeholderImage: UIImage?, completionHandler: ((image: UIImage?, error: NSError?) -> ())?) {
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        let options: KingfisherOptionsInfo = [
            // .ForceRefresh,
            // .DownloadPriority(0.5),
            .CallbackDispatchQueue(queue),
            .Transition(ImageTransition.Fade(0.15))
        ]
        self.kf_setImageWithURL(URL, placeholderImage: placeholderImage, optionsInfo: options, progressBlock: nil) { (image, error, cacheType, imageURL) in
            if let completion = completionHandler {
                completion(image: image, error: error)
            }
        }
    }

}

class ImageView: UIImageView {

    var cornerRadius: CGFloat = 0.0
    var borderWidth: CGFloat = 0.0
    var borderColor: UIColor?
    var tappableOffset: CGFloat = 0.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let layer = self.layer
        layer.borderWidth = self.borderWidth
        layer.borderColor = self.borderColor?.CGColor
        layer.cornerRadius = self.cornerRadius
        layer.masksToBounds = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
        layer.shouldRasterize = true
    }

    func configureView() {
        self.tappableOffset = 0.0
    }

}

enum ImageBorder {
    case None
    case White
    var width: CGFloat {
        switch self {
        case .None:
            return 0.0
        case .White:
            return 2.0
        }
    }
    var color: UIColor {
        switch self {
        case .None:
            return UIColor.clearColor()
        case .White:
            return UIColor.whiteColor()
        }
    }
}

class CircleImageView: ImageView {

    override func configureView() {
        super.configureView()
        self.cornerRadius = self.bounds.height / 2
    }
    
}

class WhiteBorderCircleImageView: CircleImageView {

    override func configureView() {
        super.configureView()
        self.borderWidth = 2.0
        self.borderColor = UIColor.whiteColor()
    }

}