//
//  SmileWeatherDownLoader.h
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/13/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SmileWeatherData.h"
#import "SmileWeatherDemoVC.h"

typedef void(^SmileWeatherDataDownloadCompletion)(SmileWeatherData *data, NSError *error);
typedef void(^SmileWeatherPlacemarksCompletion)(NSArray *placeMarks, NSError *error);
typedef void(^SmileWeatherRawDataCompletion)(NSDictionary *rawData, NSError *error);

typedef NS_ENUM(int, SmileWeatherAPI) {
    /*!*/
    API_wunderground,
    /*!*/
    API_openweathermap,
};


@interface SmileWeatherDownLoader : NSObject

@property (nonatomic, readonly) SmileWeatherAPI weatherAPI;

+(SmileWeatherDownLoader*)sharedDownloader;

//raw data
-(void)getWeatherRawDataFromURL:(NSURL*)url completion:(SmileWeatherRawDataCompletion)completion;

//weather data
/*!Get weather data from CLPlacemark.*/
-(void)getWeatherDataFromPlacemark:(CLPlacemark*)placeMark completion:(SmileWeatherDataDownloadCompletion)completion;

/*!Get weather data from CLLocation.*/
-(void)getWeatherDataFromLocation:(CLLocation*)location completion:(SmileWeatherDataDownloadCompletion)completion;

//Placemark Lists
/*!Get array of CLPlacemark from the input string.*/
-(void)getPlacemarksFromString:(NSString*)string completion:(SmileWeatherPlacemarksCompletion)completion;

-(void)getPlacemarksForSearchDisplayFromString:(NSString*)string completion:(SmileWeatherPlacemarksCompletion)completion;

//Utility
+(NSString*)placeNameForSearchDisplay:(CLPlacemark*)placemark;
+(NSString*)placeNameForDisplay:(CLPlacemark*)placemark;
-(NSString*)preferedLanguage;

@end
