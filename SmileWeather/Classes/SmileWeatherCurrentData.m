//
//  SmileWeatherCurrentData.m
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/24/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmileWeatherCurrentData.h"

@implementation SmileWeatherCurrentData

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
    
    NSString *all = [NSString stringWithFormat:@"~CurrentData~\rWeekday: %@,\rCondition: %@,\rHumidity: %@,\rPrecip: %@,\rWind: %@,\rWind Dir: %@,\rCurrent Temperature: %@\rPressure: %@,\rPressure Trend: %@\rUV: %@\rSunrise: %@\rSunset:%@\r", self.dayOfWeek, self.condition, self.humidity, self.precipitation, self.windSpeed, self.windDirection, self.currentTempStri_Celsius, self.pressure, self.pressureTrend, self.UV, self.sunRise, self.sunSet];
    
    return all;
}

@end
