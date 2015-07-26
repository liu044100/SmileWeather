//
//  SmileWeatherHourlyData.m
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/24/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmileWeatherHourlyData.h"

@implementation SmileWeatherHourlyData

-(NSString *)currentTempStri_Celsius {
    if (self.currentTemperature.initialized) {
        return [NSString stringWithFormat:@"%.0fº", self.currentTemperature.celsius];
    } else {
        return @"--";
    }
}

-(NSString *)currentTempStri_Fahrenheit {
    if (self.currentTemperature.initialized) {
        return [NSString stringWithFormat:@"%.0fº", self.currentTemperature.fahrenheit];
    } else {
        return @"--";
    }
}

-(NSString *)description{
    NSString *all = [NSString stringWithFormat:@"~HourlyData~\rWeekday: %@,\rCondition: %@,\rHumidity: %@,\rPrecip: %@,\rWind: %@,\rWind Dir: %@,\rTime: %@,\rCurrent Temperature: %@", self.dayOfWeek, self.condition, self.humidity, self.precipitation, self.windSpeed, self.windDirection, self.localizedTime, self.currentTempStri_Celsius];
    
    return all;
}

@end
