//
//  SmileWeatherHourlyData.m
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/24/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmileWeatherHourlyData.h"

@implementation SmileWeatherHourlyData

static NSString * const SmileCoder_localizedTime = @"localizedTime";
static NSString * const SmileCoder_hourlyDate = @"hourlyDate";
static NSString * const SmileCoder_hourlyTemp = @"hourlyTemp";

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:self.localizedTime forKey:SmileCoder_localizedTime];
    [encoder encodeObject:self.date forKey:SmileCoder_hourlyDate];
    
    NSData *temData = [NSData dataWithBytes:&_currentTemperature length:sizeof(SmileTemperature)];
    [encoder encodeObject:temData forKey:SmileCoder_hourlyTemp];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        _localizedTime = [decoder decodeObjectForKey:SmileCoder_localizedTime];
        _date = [decoder decodeObjectForKey:SmileCoder_hourlyDate];
        
        NSData *temData = [decoder decodeObjectForKey:SmileCoder_hourlyTemp];
        [temData getBytes:&_currentTemperature];
    }
    return self;
}

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
