//
//  SmileWeatherData.m
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/13/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmileWeatherData.h"
#import "SmileClimacons.h"
#import "NSString+SmileSubstring.h"
#import "SmileWeatherDownLoader.h"

@interface SmileWeatherData()

@property (nonatomic, readwrite) SmileWeatherCurrentData *currentData;
@property (nonatomic, readwrite) NSArray *forecastDatas;
@property (nonatomic, readwrite) NSArray *hourlyDatas;
@property (nonatomic, readwrite) CLPlacemark *placeMark;
@property (nonatomic, readwrite) NSDate *timeStamp;
@property (nonatomic, readwrite) NSTimeZone *timeZone;
@property (nonatomic, readwrite) NSString *placeName;
@end

@implementation SmileWeatherData

#pragma mark - Description

-(NSString *)description{
    NSString *all = [NSString stringWithFormat:@"%@\r\r%@\r\r%@\r%@\r", self.placeName, self.currentData, self.forecastDatas, self.hourlyDatas];
    return all;
}

#pragma mark - Setter

-(void)setTimeZone:(NSTimeZone *)timeZone{
    _timeZone = timeZone;
    [self hourlyDateFormatter].timeZone = timeZone;
    [self weekdayDateFormatter].timeZone = timeZone;
    [self ampmDateFormatter].timeZone = timeZone;
}

-(instancetype)initWithJSON:(NSDictionary*)jsonData inPlacemark:(CLPlacemark *)placeMark {
    if(self = [super init]) {
        self.placeMark = placeMark;
        self.placeName = [SmileWeatherDownLoader placeNameForDisplay:self.placeMark];

        self.timeStamp = [NSDate date];
        [self configureFromJSON:jsonData];
    }
    return self;
}

-(NSArray*)createOneDayDatasForForecast:(NSArray*)forecastDatas{
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:forecastDatas.count];
    
    [forecastDatas enumerateObjectsUsingBlock:^(NSDictionary *forecastday, NSUInteger idx, BOOL *stop) {
        SmileWeatherForecastDayData *forecast = [[SmileWeatherForecastDayData alloc] init];

        NSDateFormatter *weekdayFormatter = [self weekdayDateFormatter];
        
        //forecast weekday
        forecast.dayOfWeek = [weekdayFormatter stringFromDate:[self.timeStamp dateByAddingTimeInterval:60 * 60 * 24 * idx]];
        
        //condition
        NSString *condition = [forecastday valueForKey:@"conditions"];
        NSString *icon = [forecastday valueForKey:@"icon"];
        
        forecast.condition = condition;
        forecast.icon = [self iconForCondition:icon];
        
        //forecast temperature
        forecast.highTemperature = [self createSmileTemperatureFromObject:[forecastday valueForKey:@"high"] forKey_F:@"fahrenheit" forKey_C:@"celsius"];
        forecast.lowTemperature = [self createSmileTemperatureFromObject:[forecastday valueForKey:@"low"] forKey_F:@"fahrenheit" forKey_C:@"celsius"];
        
        //precipitation
        forecast.precipitationRaw = [forecastday valueForKey:@"pop"];
        
        //avehumidity
        forecast.humidity = [NSString stringWithFormat:@"%@%%", [forecastday valueForKey:@"avehumidity"]];
        
        //wind speed
        forecast.windSpeed = [self createWindSpeedStringFromObject:[[forecastday valueForKey:@"avewind"] valueForKey:@"kph"]];
        forecast.windDirection = [[forecastday valueForKey:@"avewind"] valueForKey:@"dir"];
        
        [results addObject:forecast];
    }];
    
    return [NSArray arrayWithArray:results];
}

-(NSArray*)createOneDayDatasForHourly:(NSArray*)hourlyDatas{
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:hourlyDatas.count];
    
    NSDateFormatter *hourlyDateFormatter = [self hourlyDateFormatter];
    [hourlyDatas enumerateObjectsUsingBlock:^(NSDictionary *hourlyData, NSUInteger idx, BOOL *stop) {
        SmileWeatherHourlyData *forecast = [[SmileWeatherHourlyData alloc] init];
        
        //time
        NSDictionary *timeDic  = [hourlyData valueForKey:@"FCTTIME"];

        NSString *dateStri = [NSString stringWithFormat:@"%@/%@/%@ %@:00:00",[timeDic valueForKey:@"year"], [timeDic valueForKey:@"mon_padded"], [timeDic valueForKey:@"mday_padded"], [timeDic valueForKey:@"hour_padded"]];
        
        forecast.date = [hourlyDateFormatter dateFromString:dateStri];
//        NSLog(@"%@==============%@", dateStri, forecast.date);
        //condition
        NSString *condition = [hourlyData valueForKey:@"conditions"];
        NSString *icon = [hourlyData valueForKey:@"icon"];
        
        forecast.condition = condition;
        forecast.icon = [self iconForCondition:icon];
        
        //forecast temperature
        forecast.currentTemperature = [self createSmileTemperatureFromObject:[hourlyData valueForKey:@"temp"] forKey_F:@"english" forKey_C:@"metric"];
        
        //precipitation
        forecast.precipitationRaw = [hourlyData valueForKey:@"pop"];
        
        //avehumidity
        forecast.humidity = [NSString stringWithFormat:@"%@%%", [hourlyData valueForKey:@"humidity"]];
        
        //wind
        forecast.windSpeed = [self createWindSpeedStringFromObject:[[hourlyData valueForKey:@"wspd"] valueForKey:@"metric"]];
        forecast.windDirection = [[hourlyData valueForKey:@"wdir"] valueForKey:@"dir"];
        
        [results addObject:forecast];
    }];
    
    NSDateFormatter *ampmDateFormatter = [self ampmDateFormatter];
    for (SmileWeatherHourlyData *data in results) {
        data.localizedTime = [ampmDateFormatter stringFromDate:data.date];
    }
    
    return [NSArray arrayWithArray:results];
}

-(void)configureJSON_wunderground:(NSDictionary*)jsonData{
    NSDictionary *currentObservation = [jsonData objectForKey:@"current_observation"];
    NSArray *hourlyForecastDays = [jsonData objectForKey:@"hourly_forecast"];
    
    NSDictionary *forecast = [jsonData objectForKey:@"forecast"];
    NSDictionary *simpleforecast = [forecast objectForKey:@"simpleforecast"];
    NSArray *forecastday = [simpleforecast objectForKey:@"forecastday"];
    
    
    NSDictionary *forecastday0 = [forecastday objectAtIndex:0];
    
    //weather one day data
    self.currentData = [[SmileWeatherCurrentData alloc] init];
    
    //time zone
    NSString *tz_short = [currentObservation valueForKey:@"local_tz_short"];
    NSDateFormatter *weekdayFormatter = [self weekdayDateFormatter];
    self.timeZone = [NSTimeZone timeZoneWithAbbreviation:tz_short];
    
    //today weekday
    self.currentData.dayOfWeek = [weekdayFormatter stringFromDate:self.timeStamp];
    

    //condition
    NSString *currentCondition = [currentObservation valueForKey:@"weather"];
    NSString *currentIcon = [currentObservation valueForKey:@"icon"];
    
    self.currentData.condition = currentCondition;
    self.currentData.icon = [self iconForCondition:currentIcon];
    
    
    //temperature
    //today temperature
    self.currentData.currentTemperature = [self createSmileTemperatureFromObject:currentObservation forKey_F:@"temp_f" forKey_C:@"temp_c"];
    
    
    //precipitation
    self.currentData.precipitationRaw = [forecastday0 valueForKey:@"pop"];
    
    //avehumidity
    self.currentData.humidity = [NSString stringWithFormat:@"%@", [currentObservation valueForKey:@"relative_humidity"]];
    
    
    //wind speed
    self.currentData.windSpeed = [self createWindSpeedStringFromObject:[currentObservation valueForKey:@"wind_kph"]];
    self.currentData.windDirection = [currentObservation valueForKey:@"wind_dir"];
    
    //today only property
    self.currentData.pressure = [self createPressureStringFromObject:[currentObservation valueForKey:@"pressure_mb"]];
    self.currentData.pressureTrend = [currentObservation valueForKey:@"pressure_trend"];
    self.currentData.UV = [currentObservation valueForKey:@"UV"];
    self.currentData.sunRise = [self createSunStringFromObject:[[jsonData valueForKey:@"moon_phase"]  valueForKey:@"sunrise"]];
    self.currentData.sunSet = [self createSunStringFromObject:[[jsonData valueForKey:@"moon_phase"]  valueForKey:@"sunset"]];
    
    //hourly datas
    self.hourlyDatas = [self createOneDayDatasForHourly:hourlyForecastDays];
    
    //forecast datas
    self.forecastDatas = [self createOneDayDatasForForecast:forecastday];
}

-(void)configureJSON_openweathermap:(NSDictionary*)jsonData{
    //weather one day data
//    self.todayData = [[SmileWeatherOneDayData alloc] init];
//    SmileWeatherOneDayData *forecast1 = [[SmileWeatherOneDayData alloc] init];
//    SmileWeatherOneDayData *forecast2 = [[SmileWeatherOneDayData alloc] init];
//    SmileWeatherOneDayData *forecast3 = [[SmileWeatherOneDayData alloc] init];
//    SmileWeatherOneDayData *forecast4 = [[SmileWeatherOneDayData alloc] init];
//    SmileWeatherOneDayData *forecast5 = [[SmileWeatherOneDayData alloc] init];
//    
//    NSArray *currentObservation = [jsonData objectForKey:@"weather"];
//    
//    self.todayData.condition = [[currentObservation lastObject] valueForKey:@"description"];
;
}

-(void)configureFromJSON:(NSDictionary*)jsonData{
    if ([SmileWeatherDownLoader sharedDownloader].weatherAPI == API_wunderground) {
        [self configureJSON_wunderground:jsonData];
    } else if ([SmileWeatherDownLoader sharedDownloader].weatherAPI == API_openweathermap){
        [self configureJSON_openweathermap:jsonData];
    }
}

-(NSString*)createSunStringFromObject:(NSDictionary*)object{
    NSString *result;
    
    id hour = object[@"hour"];
    id min = object[@"minute"];
    
    if ([hour isKindOfClass:[NSString class]] && [min isKindOfClass:[NSString class]]) {
        NSString *hourStri = (NSString*)hour;
        NSString *minStri = (NSString*)min;
        if (hourStri.length > 0 && minStri.length > 0) {
            result = [NSString stringWithFormat:@"%@:%@", hourStri, minStri];
        } else {
            result = @"--:--";
        }
    } else {
        result = @"--:--";
    }
    
    return result;
}

-(NSString*)createPressureStringFromObject:(id)object {
    NSString *result;
    
    if ([object isKindOfClass:[NSString class]]) {
        NSString *value = (NSString*)object;
        if (value.length > 0) {
            result = [NSString stringWithFormat:@"%@ hPa", object];
        } else {
            result = @"-- hPa";
        }
    } else {
        result = @"-- hPa";
    }
    
    return result;
}

-(NSString*)createWindSpeedStringFromObject:(id)object {
    NSString *result;
    
    if ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]]) {
        CGFloat value = [object floatValue]* 1000 / (60 * 60);
        result = [NSString stringWithFormat:@"%.0f M/S", value];
    } else {
        result = @"-- M/S";
    }
    
    return result;
}

-(SmileTemperature)createSmileTemperatureFromObject:(id)object forKey_F:(NSString*)key_f forKey_C:(NSString*)key_c {
    
    SmileTemperature result;
    
    id object_f = [object valueForKey:key_f];
    id object_c = [object valueForKey:key_c];
    
    if ([object_f isKindOfClass:[NSNumber class]] && [object_c isKindOfClass:[NSNumber class]]) {
        CGFloat value_f = [object_f doubleValue];
        CGFloat value_c = [object_c doubleValue];
        result = SmileTemperatureMake(value_f, value_c, YES);
    } else if([object_f isKindOfClass:[NSString class]] && [object_c isKindOfClass:[NSString class]]){
        CGFloat value_f = [object_f doubleValue];
        CGFloat value_c = [object_c doubleValue];
        result = SmileTemperatureMake(value_f, value_c, YES);

    }
    else {
        result = SmileTemperatureMake(0, 0, NO);
    }
    
    return result;
}

- (NSString *)iconForCondition:(NSString *)condition
{
//    NSLog(@"^^^^^^^^^^^^^^^^^^^^^^raw: %@", condition);
    NSString *iconName = [NSString stringWithFormat:@"%c", ClimaconSun];
    NSString *lowercaseCondition = [condition lowercaseString];
    
    if([lowercaseCondition contains:@"clear"] || [lowercaseCondition contains:@"sunny"]) {
        iconName = [NSString stringWithFormat:@"%c", ClimaconSun];
    }
    
    else if([lowercaseCondition contains:@"cloudy"]) {
        iconName = [NSString stringWithFormat:@"%c", ClimaconCloud];
    }

    else if ([lowercaseCondition contains:@"rain"]){
        iconName = [NSString stringWithFormat:@"%c", ClimaconRain];
    }
    
    else if ([lowercaseCondition contains:@"storms"]){
        iconName = [NSString stringWithFormat:@"%c", ClimaconDownpour];
    }
    
    else if([lowercaseCondition contains:@"fog"] || [lowercaseCondition contains:@"hazy"]){
        iconName = [NSString stringWithFormat:@"%c", ClimaconHaze];
    }
    
    else if ([lowercaseCondition contains:@"sleet"]){
        iconName = [NSString stringWithFormat:@"%c", ClimaconSleet];
    }
    
    else if ([lowercaseCondition contains:@"flurries"]){
        iconName = [NSString stringWithFormat:@"%c", ClimaconFlurries];
    }
    
    else if ([lowercaseCondition contains:@"snow"]){
        iconName = [NSString stringWithFormat:@"%c", ClimaconSnow];
    }
    
    else {
        iconName = @"";
    }
    return iconName;
}

-(NSDateFormatter*)ampmDateFormatter{
    static dispatch_once_t onceToken;
    static NSDateFormatter *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[NSDateFormatter alloc] init];
        [_sharedInstance setTimeStyle:NSDateFormatterShortStyle];
    });
    return _sharedInstance;
}

-(NSDateFormatter*)hourlyDateFormatter{
    static dispatch_once_t onceToken;
    static NSDateFormatter *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[NSDateFormatter alloc] init];
        [_sharedInstance setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        _sharedInstance.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    });
    return _sharedInstance;
}

-(NSDateFormatter*)weekdayDateFormatter {
    static dispatch_once_t onceToken;
    static NSDateFormatter *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[NSDateFormatter alloc] init];
        [_sharedInstance setDateFormat:@"EEE"];
    });
    return _sharedInstance;
}

@end
