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

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    CLLocation *location = [self getLocation];
    [[SmileWeatherDownLoader sharedDownloader] getWeatherDataFromLocation:location completion:^(SmileWeatherData *data, NSError *error) {
        if (error) {
            NSLog(@"error -> %@", error.localizedDescription);
        } else {
            self.placeLabel.text = data.placeName;
            self.tempLabel.text = data.currentData.currentTempStri_Celsius;
            self.weatherLabel.text = data.currentData.icon;
        }
    }];

}

-(CLLocation*)getLocation{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(37.322998,-122.032182);
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    return location;
}

@end



