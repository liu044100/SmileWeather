//
//  TodayViewController.m
//  SmileWeatherTodayWidget
//
//  Created by yuchen liu on 9/14/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import <SmileWeatherDownLoader.h>

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(0, 80);
    
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

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    completionHandler(NCUpdateResultNewData);
}

@end
