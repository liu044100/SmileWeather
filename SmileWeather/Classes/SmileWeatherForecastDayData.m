//
//  SmileWeatherForecastDayData.m
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/24/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmileWeatherForecastDayData.h"

@implementation SmileWeatherForecastDayData

static NSString * const SmileCoder_forecastHighTemp = @"forecastHighTemp";
static NSString * const SmileCoder_forecastLowTemp = @"forecastLowTemp";

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];

    NSData *temData_high = [NSData dataWithBytes:&_highTemperature length:sizeof(SmileTemperature)];
    [encoder encodeObject:temData_high forKey:SmileCoder_forecastHighTemp];

    
    NSData *temData_low = [NSData dataWithBytes:&_lowTemperature length:sizeof(SmileTemperature)];
    [encoder encodeObject:temData_low forKey:SmileCoder_forecastLowTemp];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        NSData *temData_high = [decoder decodeObjectForKey:SmileCoder_forecastHighTemp];
        [temData_high getBytes:&_highTemperature];
        
        NSData *temData_low = [decoder decodeObjectForKey:SmileCoder_forecastLowTemp];
        [temData_low getBytes:&_lowTemperature];
    }
    return self;
}


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
