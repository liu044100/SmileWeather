//
//  SmileWeatherCurrentData.m
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/24/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmileWeatherCurrentData.h"

@implementation SmileWeatherCurrentData

static NSString * const SmileCoder_UV = @"UV";
static NSString * const SmileCoder_pressure = @"pressure";
static NSString * const SmileCoder_pressureTrend = @"pressureTrend";
static NSString * const SmileCoder_currentTemp = @"currentTemp";

static NSString * const SmileCoder_sunrise = @"sunrise";
static NSString * const SmileCoder_sunset = @"sunset";

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:self.UV forKey:SmileCoder_UV];
    [encoder encodeObject:self.pressure forKey:SmileCoder_pressure];
    [encoder encodeObject:self.pressureTrend forKey:SmileCoder_pressureTrend];
    [encoder encodeObject:self.sunRise forKey:SmileCoder_sunrise];
    [encoder encodeObject:self.sunSet forKey:SmileCoder_sunset];

    NSData *temData = [NSData dataWithBytes:&_currentTemperature length:sizeof(SmileTemperature)];
    [encoder encodeObject:temData forKey:SmileCoder_currentTemp];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        _UV = [decoder decodeObjectForKey:SmileCoder_UV];
        _pressure = [decoder decodeObjectForKey:SmileCoder_pressure];
        _pressureTrend = [decoder decodeObjectForKey:SmileCoder_pressureTrend];
        _sunRise = [decoder decodeObjectForKey:SmileCoder_sunrise];
        _sunSet = [decoder decodeObjectForKey:SmileCoder_sunset];
        
        NSData *temData = [decoder decodeObjectForKey:SmileCoder_currentTemp];
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
    
    NSString *all = [NSString stringWithFormat:@"~CurrentData~\rWeekday: %@,\rCondition: %@,\rHumidity: %@,\rPrecip: %@,\rWind: %@,\rWind Dir: %@,\rCurrent Temperature: %@\rPressure: %@,\rPressure Trend: %@\rUV: %@\rSunrise: %@\rSunset:%@\r", self.dayOfWeek, self.condition, self.humidity, self.precipitation, self.windSpeed, self.windDirection, self.currentTempStri_Celsius, self.pressure, self.pressureTrend, self.UV, self.sunRise, self.sunSet];
    
    return all;
}

@end
