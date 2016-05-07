//
//  SmileWeatherOneDayData.h
//  SmileWeather-Example
//
//  Created by yuchen liu on 7/13/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+SmileSubstring.h"

typedef struct {
    float fahrenheit;
    float celsius;
    BOOL initialized;
} SmileTemperature;

static inline SmileTemperature SmileTemperatureMake(float fahrenheit, float celsius, BOOL initialized) {
    return (SmileTemperature){
        fahrenheit, celsius, initialized
    };
}


@interface SmileWeatherOneDayData : NSObject <NSCoding>

//use NSTimeZone calculate
@property (copy, nonatomic) NSString *dayOfWeek;

//today & forecast shared
//conditions	:	Fog
@property (copy, nonatomic) NSString *icon;
@property (copy, nonatomic) NSString *condition;

/*
 "temp_f": 66.3, "temp_c": 19.1,
 high =                     {
 celsius = 28;
 fahrenheit = 83;
 };
 
 low =                     {
 celsius = 23;
 fahrenheit = 73;
 };
 */

//pop = 90;
///Openweathermap unit: mm, Wunderground unit: %
@property (copy, nonatomic) NSString *precipitationRaw;
@property (readonly, nonatomic) NSString *precipitation;

//"relative_humidity": "65%", avehumidity = 82;
@property (copy, nonatomic) NSString *humidity;
/*
"wind_kph": 35.4,
avewind =                     {
    degrees = 105;
    dir = ESE;
    kph = 24;
    mph = 15;
};
 */
///unit is M/S
@property (copy, nonatomic) NSString *windSpeedRaw;
@property (readonly, nonatomic) NSString *windSpeed;
///etc. Openweathermap: 200,　Wunderground: SSW
@property (copy, nonatomic) NSString *windDirection;


@end
