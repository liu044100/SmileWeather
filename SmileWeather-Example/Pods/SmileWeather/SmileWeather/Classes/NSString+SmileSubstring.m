//
//  NSString+SmileSubstring.m
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/14/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "NSString+SmileSubstring.h"

@implementation NSString (SmileSubstring)
- (BOOL)contains:(NSString *)substring
{
    NSRange range = [self rangeOfString:substring];
    return range.length != 0;
}

@end
