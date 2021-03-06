//
//  SoundCastUITests.swift
//  SoundCastUITests
//
//  Created by Ankur on 1/18/19.
//  Copyright © 2019 ankur. All rights reserved.
//

import XCTest

class SoundCastUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {

        let tablesQuery = XCUIApplication().tables
        
        XCTAssertEqual(tablesQuery.count, 1)
        
        let table = tablesQuery.allElementsBoundByIndex[0]
        //XCTAssertEqual(table.cells.count, 0)
        
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["The Amazing Spider Man"].swipeRight()/*[[".cells.staticTexts[\"The Amazing Spider Man\"]",".swipeUp()",".swipeRight()",".staticTexts[\"The Amazing Spider Man\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        
        XCTAssertEqual(table.cells.count, 100)
       
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
