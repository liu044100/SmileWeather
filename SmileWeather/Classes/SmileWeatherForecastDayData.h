//
//  SmileWeatherForecastDayData.h
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/24/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmileWeatherOneDayData.h"

@interface SmileWeatherForecastDayData : SmileWeatherOneDayData

@property (nonatomic) SmileTemperature highTemperature;
@property (nonatomic) SmileTemperature lowTemperature;

@property (copy, nonatomic) NSString *highTempStri_Celsius;
@property (copy, nonatomic) NSString *highTempStri_Fahrenheit;

@property (copy, nonatomic) NSString *lowTempStri_Celsius;
@property (copy, nonatomic) NSString *lowTempStri_Fahrenheit;

@end
