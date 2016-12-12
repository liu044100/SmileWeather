//
//  SmileWeather_ExapleTests_Swift.swift
//  SmileWeather-Example
//
//  Created by yuchen liu on 10/19/15.
//  Copyright © 2015 rain. All rights reserved.
//

import XCTest

class SmileWeather_ExapleTests_Swift: XCTestCase {
    
    let sharedDownloader = SmileWeatherDownLoader.sharedDownloader()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func locationForTest() -> CLLocation {
        let coordinate = CLLocationCoordinate2D(latitude: 37.322998, longitude: -122.032182)
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    func test_Downloader_init() {
        let sharedInstance = SmileWeatherDownLoader.sharedDownloader()
        XCTAssertNotNil(sharedInstance, "SmileWeatherDownLoader failed to instance");
    }
    
    func test_Asyn_download() {
        let completionExpectation = self.expectation(description: "Asyn Download")
        
        sharedDownloader.getWeatherData(from: self.locationForTest()) { (data: SmileWeatherData?, error: Error?) in
            XCTAssertNil(error, "SmileWeatherDownLoader failed download weather info")
            XCTAssertTrue(data!.forecastData.count > 0, "SmileWeatherDownLoader failed download forecastData")
            XCTAssertTrue(data!.hourlyData.count > 0, "SmileWeatherDownLoader failed download hourlyData")
            completionExpectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_Asyn_search() {
        let completionExpectation = self.expectation(description: "Asyn Search")
        
        sharedDownloader.getPlacemarks(from: "Tokyo") { (places: [CLPlacemark]?, error: Error?) in
            XCTAssertNil(error, "SmileWeatherDownLoader failed search places info")
            XCTAssertTrue(places!.count > 0, "SmileWeatherDownLoader failed placeMark array")
            completionExpectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
