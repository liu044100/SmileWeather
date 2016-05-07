//
//  InterfaceController.m
//  SmileWeatherWatch Extension
//
//  Created by yuchen liu on 5/7/16.
//  Copyright © 2016 rain. All rights reserved.
//

#import "InterfaceController.h"
#import <SmileWeatherDownLoader.h>

@interface InterfaceController()
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *weatherLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *tempLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *placeLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *conditionLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *maxTempLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *minTempLabel;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    [self resetLabelText];
    
    CLLocation *location = [self getLocation];
    [[SmileWeatherDownLoader sharedDownloader] getWeatherDataFromLocation:location completion:^(SmileWeatherData *data, NSError *error) {
        if (error) {
            NSLog(@"error -> %@", error.localizedDescription);
        } else {
            self.placeLabel.text = data.placeName;
            self.tempLabel.text = data.currentData.currentTempStri_Celsius;
            self.weatherLabel.text = data.currentData.icon;
            self.conditionLabel.text = data.currentData.condition;
            SmileWeatherForecastDayData *forecastData = data.forecastData.firstObject;
            self.maxTempLabel.text = forecastData.highTempStri_Celsius;
            self.minTempLabel.text = forecastData.lowTempStri_Celsius;
        }
    }];

}

-(void)resetLabelText {
    NSString *blank = @"--";
    self.placeLabel.text = blank;
    self.conditionLabel.text = blank;
    self.tempLabel.text = blank;
    self.maxTempLabel.text = blank;
    self.minTempLabel.text = blank;
    self.weatherLabel.text = @"";
}

-(CLLocation*)getLocation{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(37.322998,-122.032182);
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    return location;
}

@end



