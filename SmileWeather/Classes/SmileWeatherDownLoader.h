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
typedef void(^SmileWeatherRawDicCompletion)(NSDictionary *rawDic, NSError *error);
typedef void(^SmileWeatherRawDataCompletion)(NSData *rawData, NSError *error);


typedef NS_ENUM(int, SmileWeatherAPI) {
    /*!*/
    API_wunderground,
    /*!*/
    API_openweathermap,
};


@interface SmileWeatherDownLoader : NSObject

/*!The weather api used for your project, please set it in your info.plist in advance.*/
@property (nonatomic, readonly) SmileWeatherAPI weatherAPI;

+(SmileWeatherDownLoader*)sharedDownloader;

//raw data
-(void)getWeatherRawDataFromURL:(NSURL*)url completion:(SmileWeatherRawDataCompletion)completion;

-(void)getWeatherRawDicFromURL:(NSURL*)url completion:(SmileWeatherRawDicCompletion)completion;

//weather data
/*!
 @brief Get weather data from CLPlacemark.
 @discussion This method submits the specified CLPlacemark data to the weather server asynchronously and returns well formed data 'SmileWeatherData' for using easily. Your completion handler block will be executed on the main thread.
 @param placeMark The CLPlacemark is submited for weather data.
 @param completion A block object containing the code to execute at the end of the request. This code is called whether the request is successful or unsuccessful.
 @see -getWeatherDataFromLocation:completion:
 */
-(void)getWeatherDataFromPlacemark:(CLPlacemark*)placeMark completion:(SmileWeatherDataDownloadCompletion)completion;

/*!
 @brief Get weather data from CLLocation.
 @discussion This method submits the specified CLLocation data to the weather server asynchronously and returns well formed data 'SmileWeatherData' for using easily. Your completion handler block will be executed on the main thread.
 @param location The CLPlacemark is submited for weather data.
 @param completion A block object containing the code to execute at the end of the request. This code is called whether the request is successful or unsuccessful.
 @see -getWeatherDataFromPlacemark:completion:
 */
-(void)getWeatherDataFromLocation:(CLLocation*)location completion:(SmileWeatherDataDownloadCompletion)completion;

//Placemark Lists
/*!
 @brief Get array of CLPlacemark from the input string in the normal scene.
 @discussion This method submits the specified String to the weather server asynchronously and returns array of CLPlacemark. Your completion handler block will be executed on the main thread.
 @param string The string is submited for search.
 @param completion A block object containing the code to execute at the end of the request. This code is called whether the request is successful or unsuccessful.
 @see -getPlacemarksForSearchDisplayFromString:completion:
 */
-(void)getPlacemarksFromString:(NSString*)string completion:(SmileWeatherPlacemarksCompletion)completion;

/*!
 @brief Get array of CLPlacemark from the input string for display in the scene where the results is displayed in the search bar. By use this method, the returned array will contains the corresponding results as much as possible.
 @discussion This method submits the specified string to the weather server asynchronously and returns array of CLPlacemark. Your completion handler block will be executed on the main thread.
 @param string The string is submited for search.
 @param completion A block object containing the code to execute at the end of the request. This code is called whether the request is successful or unsuccessful.
 @see -getPlacemarksFromString:completion:
 */
-(void)getPlacemarksForSearchDisplayFromString:(NSString*)string completion:(SmileWeatherPlacemarksCompletion)completion;

//Utility
/*!Optimized placename for display in the search bar scene.*/
+(NSString*)placeNameForSearchDisplay:(CLPlacemark*)placemark;
/*!Optimized placename for display in the normal scene.*/
+(NSString*)placeNameForDisplay:(CLPlacemark*)placemark;
/*!Current prefered language for device.*/
-(NSString*)preferedLanguage;

@end
