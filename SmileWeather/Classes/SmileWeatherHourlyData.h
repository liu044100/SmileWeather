//
//  SmileWeatherHourlyData.h
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/24/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmileWeatherOneDayData.h"

@interface SmileWeatherHourlyData : SmileWeatherOneDayData

//hourly data only
/*
 "FCTTIME":{
 "civil": "9:00 PM"
 }
 */
@property (copy, nonatomic) NSString *localizedTime;
@property (nonatomic) NSDate *date;
@property (nonatomic) SmileTemperature currentTemperature;
@property (copy, nonatomic) NSString *currentTempStri_Celsius;
@property (copy, nonatomic) NSString *currentTempStri_Fahrenheit;

@end
