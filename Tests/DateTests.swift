// DateTests.swift
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

import XCTest

class DateTests: XCTestCase {

    let formatter: NSDateFormatter = NSDateFormatter()

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testString() {
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss Z"

        let fromString = "2015/03/04 08:04:56 +09:00"
        let toString = "2015/03/04 14:50:56 +09:00"
        let from: NSDate? = formatter.dateFromString(fromString)
        let to: NSDate? = formatter.dateFromString(toString)

        XCTAssertEqual("AM 08:04 - ", NSDate.string(.TourList, from: from, to: nil))
        XCTAssertEqual(" - PM 02:50", NSDate.string(.TourList, from: nil, to: to))
        XCTAssertEqual("AM 08:04 - PM 02:50", NSDate.string(.TourList, from: from, to: to))
    }

}
