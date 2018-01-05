//
//  Wordify.test.swift
//  ReleaseNumberToWords
//
//  Created by Volare on 09/12/2017.
//  Copyright © 2017 Volare. All rights reserved.

import XCTest

class Wordify_test: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(wordifyNum(number: 123), "one hundred and twenty-three")
        XCTAssertEqual(wordifyNum(number: 456), "four hundred and fifty-six")
        XCTAssertEqual(wordifyNum(number: 444222), "four hundred and forty-four thousand two hundred and twenty-two")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
