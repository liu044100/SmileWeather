//
//  SmileWeatherForecastDayData.h
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/24/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmileWeatherOneDayData.h"

@interface SmileWeatherForecastDayData : SmileWeatherOneDayData <NSCoding>

@property (nonatomic) SmileTemperature highTemperature;
@property (nonatomic) SmileTemperature lowTemperature;

@property (readonly, nonatomic) NSString *highTempStri_Celsius;
@property (readonly, nonatomic) NSString *highTempStri_Fahrenheit;

@property (readonly, nonatomic) NSString *lowTempStri_Celsius;
@property (readonly, nonatomic) NSString *lowTempStri_Fahrenheit;

@end
