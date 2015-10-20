//
//  SmileWeather_ExampleTests.m
//  SmileWeather-ExampleTests
//
//  Created by ryu-ushin on 7/13/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "NSBundle+SmileTestAdditions.h"
#import <SmileWeatherDownLoader.h>

@interface SmileWeatherDownLoader (SmileTestExtension)
-(NSURL*)urlForLocation:(CLLocation *)location;
@end

@interface SmileWeatherData (SmileTestExtension)
@property (nonatomic, readwrite) SmileWeatherAPI weatherAPI;
-(void)configureForecastDaysAndHourly_openweathermap:(NSArray*)object;
@end

@interface SmileWeather_ExampleTests : XCTestCase

@property(nonatomic, strong) SmileWeatherDownLoader *sharedDownloader;

@end

@implementation SmileWeather_ExampleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(SmileWeatherDownLoader *)sharedDownloader{
    if (!_sharedDownloader) {
        _sharedDownloader = [SmileWeatherDownLoader sharedDownloader];
    }
    return _sharedDownloader;
}

-(CLLocation*)locationForTest{
    static CLLocation *location;
    if (!location) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(37.322998,-122.032182);
        location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    }
    return location;
}

-(void)test_Downloader_init{
    SmileWeatherDownLoader *sharedInstance = [SmileWeatherDownLoader sharedDownloader];
    XCTAssertNotNil(sharedInstance, @"SmileWeatherDownLoader failed to instance");
}

-(void)test_URL_getter{
    CLLocation *location = [self locationForTest];
    NSURL *url = [self.sharedDownloader urlForLocation:location];
    XCTAssertNotNil(url, @"SmileWeatherDownLoader failed to get url");
}

-(void)test_Asyn_download{
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Asyn Download"];
    CLLocation *location = [self locationForTest];
    [self.sharedDownloader getWeatherDataFromLocation:location completion:^(SmileWeatherData * _Nullable data, NSError * _Nullable error) {
        XCTAssertNil(error, @"SmileWeatherDownLoader failed download weather info");
        XCTAssertTrue(data.forecastData.count > 0, @"SmileWeatherDownLoader failed download forecastData");
        XCTAssertTrue(data.hourlyData.count > 0, @"SmileWeatherDownLoader failed download hourlyData");
        [completionExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

-(void)test_Asyn_search{
    XCTestExpectation *completionExpectation = [self expectationWithDescription:@"Asyn Search"];
    [self.sharedDownloader getPlacemarksFromString:@"Tokyo" completion:^(NSArray<CLPlacemark *> * _Nullable placeMarks, NSError * _Nullable error) {
        XCTAssertNil(error, @"SmileWeatherDownLoader failed search places info");
        XCTAssertTrue(placeMarks.count > 0, @"SmileWeatherDownLoader failed placeMark array");
        [completionExpectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

-(void)test_Performance_createWeatherDataFromDictionary{
    NSURL *sampleURL = [[NSBundle testBundle] URLForResource:@"SampleResponse" withExtension:@"json"];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:sampleURL] options:0 error:nil];
    XCTAssert(jsonDic, @"cannot serialize json data");
    
    SmileWeatherData *weatherData = [[SmileWeatherData alloc] init];
    weatherData.weatherAPI = self.sharedDownloader.weatherAPI;
    
    [self measureBlock:^{
        [weatherData configureForecastDaysAndHourly_openweathermap:(NSArray*)[jsonDic objectForKey:@"list"]];
        XCTAssertTrue(weatherData.forecastData.count > 0, @"SmileWeatherDownLoader failed download forecastData");
        XCTAssertTrue(weatherData.hourlyData.count > 0, @"SmileWeatherDownLoader failed download hourlyData");
    }];
}

-(void)test_DemoView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    SmileWeatherDemoVC *demoVC = [SmileWeatherDemoVC DemoVCToView:view];
    XCTAssertNotNil(demoVC, @"Cannot create SmileWeatherDemoVC");
}

@end
