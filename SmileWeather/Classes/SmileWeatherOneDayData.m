//
//  SmileWeatherOneDayData.m
//  SmileWeather-Example
//
//  Created by yuchen liu on 7/13/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmileWeatherOneDayData.h"

@implementation SmileWeatherOneDayData

static NSString * const SmileCoder_dayOfWeek = @"dayOfWeek";
static NSString * const SmileCoder_icon = @"icon";
static NSString * const SmileCoder_condition = @"condition";
static NSString * const SmileCoder_precipitationRaw = @"precipitationRaw";
static NSString * const SmileCoder_humidity = @"humidity";
static NSString * const SmileCoder_windSpeed = @"windSpeed";
static NSString * const SmileCoder_windDirection = @"windDirection";

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.dayOfWeek forKey:SmileCoder_dayOfWeek];
    [encoder encodeObject:self.icon forKey:SmileCoder_icon];
    [encoder encodeObject:self.condition forKey:SmileCoder_condition];
    [encoder encodeObject:self.precipitationRaw forKey:SmileCoder_precipitationRaw];
    [encoder encodeObject:self.humidity forKey:SmileCoder_humidity];
    [encoder encodeObject:self.windSpeed forKey:SmileCoder_windSpeed];
    [encoder encodeObject:self.windDirection forKey:SmileCoder_windDirection];
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [self init];
    if (self) {
        _dayOfWeek = [decoder decodeObjectForKey: SmileCoder_dayOfWeek];
        _icon = [decoder decodeObjectForKey: SmileCoder_icon];
        _condition = [decoder decodeObjectForKey: SmileCoder_condition];
        _precipitationRaw = [decoder decodeObjectForKey: SmileCoder_precipitationRaw];
        _humidity = [decoder decodeObjectForKey: SmileCoder_humidity];
        _windSpeed = [decoder decodeObjectForKey: SmileCoder_windSpeed];
        _windDirection = [decoder decodeObjectForKey: SmileCoder_windDirection];
    }
    return self;
}


-(NSString *)description{
    NSString *all = [NSString stringWithFormat:@"~OneDayData~\rWeekday: %@,\rCondition: %@,\rHumidity: %@,\rPrecip: %@,\rWind: %@,\rWind Dir: %@", self.dayOfWeek, self.condition, self.humidity, self.precipitation, self.windSpeed, self.windDirection];
    
    return all;
}

-(NSString *)precipitation{
    NSString *result;
    if (_precipitationRaw) {
        if ([_precipitationRaw contains:@"mm"]) {
            result = [NSString stringWithFormat:@"%@", _precipitationRaw];
        } else {
            result = [NSString stringWithFormat:@"%@%%", _precipitationRaw];
        }
    } else {
        result = [NSString stringWithFormat:@"--%%"];
    }
    return result;
}

@end
