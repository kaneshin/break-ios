//
//  Tests.swift
//  Tests
//
//  Created by Shintaro Kaneko on 5/21/16.
//  Copyright © 2016 kaneshin.co. All rights reserved.
//

import XCTest
import API
import APIKit

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testHoge() {
        XCTAssertNotNil("", "request should not be nil")
    }

    func testExample() {

        let expectation = expectationWithDescription("Bytes download progress should be reported")

        let request = GETWelcomeRequest()

        Session.sendRequest(request) { result in
            switch result {
            case .Success(let welcomeData):
                XCTAssertEqual("", welcomeData.defaultNickname)
                XCTAssertEqual(13, welcomeData.defaultResidenceStateID)
            case .Failure(let error):
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        }
        self.waitForExpectationsWithTimeout(10.0, handler: nil)
    }

//    func testTour() {
//        let expectation = expectationWithDescription("tour")
//
//        let request = GetTourRequest()
//
//        Session.sendRequest(request) { result in
//            switch result {
//            case .Success(let welcomeData):
//                XCTAssertEqual("", welcomeData.defaultNickname)
//                XCTAssertEqual(13, welcomeData.defaultResidenceStateID)
//            case .Failure(let error):
//                XCTAssertNotNil(error)
//            }
//            expectation.fulfill()
//        }
//        self.waitForExpectationsWithTimeout(10.0, handler: nil)
//    }

}
