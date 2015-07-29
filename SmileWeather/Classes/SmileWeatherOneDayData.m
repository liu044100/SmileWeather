//
//  SmileWeatherOneDayData.m
//  SmileWeather-Example
//
//  Created by yuchen liu on 7/13/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmileWeatherOneDayData.h"

@implementation SmileWeatherOneDayData


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
