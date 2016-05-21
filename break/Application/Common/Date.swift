// Date.swift
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

enum DateLayout {
    case TourList

    var string: String {
        switch self {
        case TourList:
            return "a hh:mm"
        }
    }
}

var regularFormatter: NSDateFormatter = {
    let formatter =  NSDateFormatter()
    formatter.AMSymbol = "AM"
    formatter.PMSymbol = "PM"
    return formatter
}()

extension NSDate {
    class func string(layout: DateLayout, from: NSDate?, to: NSDate?) -> String {
        var elms: [String] = ["", ""]
        regularFormatter.dateFormat = layout.string
        if let from = from {
            elms[0] = regularFormatter.stringFromDate(from)
        }
        if let to = to {
            elms[1] = regularFormatter.stringFromDate(to)
        }
        return elms.joinWithSeparator(" - ")
    }

    func string(layout: DateLayout, to: NSDate?) -> String {
        return NSDate.string(layout, from: self, to: to)
    }
}
