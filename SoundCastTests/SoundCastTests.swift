//
//  SoundCastTests.swift
//  SoundCastTests
//
//  Created by Ankur on 1/18/19.
//  Copyright © 2019 ankur. All rights reserved.
//

import XCTest
@testable import SoundCast

class SoundCastTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHomeViewModel() {
        
        let track = Track(thumbnail: "https://static.talview.com/hiring/android/soundcast/thumbs/fast-and-furious.jpg", title: "Fast And Furious", link: "https://static.talview.com/hiring/android/soundcast/mp3/fast-and-furious.mp3")
        let homeViewModel = HomeViewModel(track: track)
        
        XCTAssertEqual(track.title, homeViewModel.title)
        XCTAssertEqual(track.link, homeViewModel.link)
        XCTAssertEqual(track.thumbnail, homeViewModel.thumbnailURL)
    }
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
