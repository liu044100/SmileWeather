//
//  SmileWeatherDemoVC.h
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/15/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmileWeatherData.h"

@interface SmileWeatherDemoVC : UIViewController

@property (nonatomic, strong) SmileWeatherData *data;
@property (nonatomic) BOOL loading;

@end
