//
//  NSBundle+SmileTestAdditions.m
//  SmileWeather-Example
//
//  Created by ryu-ushin on 10/19/15.
//  Copyright © 2015 rain. All rights reserved.
//

#import "NSBundle+SmileTestAdditions.h"

@interface DummyObject : NSObject
@end
@implementation DummyObject
@end

@implementation NSBundle (SmileTestAdditions)
+ (NSBundle *)testBundle {
    return [NSBundle bundleForClass:[DummyObject class]];
}
@end
