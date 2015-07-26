//
//  SmileWeatherForecastDayData.m
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/24/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmileWeatherForecastDayData.h"

@implementation SmileWeatherForecastDayData

-(NSString *)highTempStri_Celsius {
    if (self.highTemperature.initialized) {
        return [NSString stringWithFormat:@"%.0fº", self.highTemperature.celsius];
    } else {
        return @"--";
    }
}

-(NSString *)lowTempStri_Celsius {
    if (self.lowTemperature.initialized) {
        return [NSString stringWithFormat:@"%.0fº", self.lowTemperature.celsius];
    } else {
        return @"--";
    }
}

-(NSString *)highTempStri_Fahrenheit {
    if (self.highTemperature.initialized) {
        return [NSString stringWithFormat:@"%.0fº", self.highTemperature.fahrenheit];
    } else {
        return @"--";
    }
}

-(NSString *)lowTempStri_Fahrenheit {
    if (self.lowTemperature.initialized) {
        return [NSString stringWithFormat:@"%.0fº", self.lowTemperature.fahrenheit];
    } else {
        return @"--";
    }
}

-(NSString *)description{
    NSString *all = [NSString stringWithFormat:@"~ForecastDayData~\rWeekday: %@,\rCondition: %@,\rHumidity: %@,\rPrecip: %@,\rWind: %@,\rWind Dir: %@,\rH: %@,\rL: %@", self.dayOfWeek, self.condition, self.humidity, self.precipitation, self.windSpeed, self.windDirection, self.highTempStri_Celsius, self.lowTempStri_Celsius];
    
    return all;
}

@end
