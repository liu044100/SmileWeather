//
//  SmileWeatherDemoVC.h
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/15/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#if TARGET_OS_IOS

#import <UIKit/UIKit.h>
#import "SmileWeatherData.h"

@protocol SmileDemoChangeTempUnitsDelegate <NSObject>
@optional
-(void)changeTempUnitsToFahrenheit:(BOOL)isFahrenheit;
@end

@interface SmileWeatherDemoVC : UIViewController

@property (nonatomic, strong, nullable) SmileWeatherData *data;
@property (nonatomic) BOOL loading;
@property (nonatomic, getter= isFahrenheit) BOOL fahrenheit;
/*!Night mode will change background color to black color.*/
@property (nonatomic) BOOL nightMode;
@property (nonatomic, nonnull) UIColor *mainInterfaceColor;
@property (nonatomic, nonnull) UIColor *mainInterfaceNightModeColor;
@property (nonatomic, nonnull) UIColor *higlightedInterfaceColor;

@property (weak, nonatomic, nullable) id<SmileDemoChangeTempUnitsDelegate>delegate;
//demo vc
/*!Create a demo view for show the ability of the SmileWeather.*/
+(nonnull SmileWeatherDemoVC*)DemoVCToView:(nonnull UIView*)parentView;

@end

#endif
