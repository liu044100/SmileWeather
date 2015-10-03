//
//  ViewController.m
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/13/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "ViewController.h"
#import "SmileWeatherDownLoader.h"
#import "SearchTableVC.h"

@interface ViewController () <UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate, SmileDemoChangeTempUnitsDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) SearchTableVC *searchTableVC;
@property (nonatomic, strong) NSArray *searchResults;
@end

@implementation ViewController {
    SmileWeatherDemoVC *_demoVC;
    NSUserDefaults *_userDefaults;
}

#define IS_OS_7    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
static NSString * const reuseIdentifier = @"searchCell";
static NSString * const searchTableIdentifier = @"SearchTable";
static NSString * const demoLocation_key = @"demoLocation";

-(void)firstLaunchRegister{
    _userDefaults = [NSUserDefaults standardUserDefaults];
    
    //create demo location
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(37.322998,-122.032182);
    NSNumber *lat = [NSNumber numberWithDouble:coordinate.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:coordinate.longitude];
    NSDictionary *userLocation=@{@"lat":lat,@"long":lon};
    [_userDefaults registerDefaults:userLocation];
}

-(CLLocation*)locationInUserDefaults{
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    NSNumber *lat = [_userDefaults objectForKey:@"lat"];
    NSNumber *lon = [_userDefaults objectForKey:@"long"];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[lat doubleValue] longitude:[lon doubleValue]];
    return location;
}

-(void)saveLocationInUserDefaults:(CLLocation*)location{
    if (!_userDefaults) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSNumber *lat = [NSNumber numberWithDouble:coordinate.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:coordinate.longitude];
    [_userDefaults setObject:lat forKey:@"lat"];
    [_userDefaults setObject:lon forKey:@"long"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //register data for first launch
    [self firstLaunchRegister];
    
    //create searchbar if in iOS => iOS8
    if (!IS_OS_7) {
        //UISearchController
        [self configureSearchControllerAndSearchResultsController];
    }
    
    //create demo VC
    _demoVC = [SmileWeatherDemoVC DemoVCToView:self.containerView];
    _demoVC.delegate = self;
    
    //get weather data
    [self getWeatherData];
    
}

-(void)getWeatherData{
    //get weather data from CLLocation
    CLLocation *location = [self locationInUserDefaults];
    [[SmileWeatherDownLoader sharedDownloader] getWeatherDataFromLocation:location completion:^(SmileWeatherData *data, NSError *error) {
        if (error) {
            NSLog(@"error -> %@", error.localizedDescription);
        } else {
            _demoVC.data = data;
        }
    }];
}

-(void)configureSearchControllerAndSearchResultsController{
    //SearchResultsController
    self.searchTableVC = [self.storyboard instantiateViewControllerWithIdentifier:searchTableIdentifier];
    self.searchTableVC.tableView.delegate = self;
    self.searchTableVC.tableView.dataSource = self;
    
    //UISearchController
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.searchTableVC];
    self.searchController.searchResultsUpdater = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.dimsBackgroundDuringPresentation = YES;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.navigationItem.titleView = self.searchController.searchBar;
    self.definesPresentationContext = true;
}

#pragma mark - UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchStri = searchController.searchBar.text;
    
    [[SmileWeatherDownLoader sharedDownloader] getPlacemarksForSearchDisplayFromString:searchStri completion:^(NSArray *placeMarks, NSError *error) {
        self.searchResults = placeMarks;
        [self.searchTableVC.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchResults) {
        return self.searchResults.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (self.searchResults.count > 0) {
        CLPlacemark *placemark = self.searchResults[indexPath.row];
        cell.textLabel.text = [SmileWeatherDownLoader placeNameForSearchDisplay:placemark];
    } else {
        cell.textLabel.text = @"";
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    CLPlacemark *placemark = self.searchResults[indexPath.row];
    
    //save location
    [self saveLocationInUserDefaults:placemark.location];
    
    self.searchController.active = NO;
    _demoVC.loading = YES;
    
    //get weather data from CLPlacemark
    [[SmileWeatherDownLoader sharedDownloader] getWeatherDataFromPlacemark:placemark completion:^(SmileWeatherData *data, NSError *error) {
        if (error) {
            NSLog(@"error -> %@", error.localizedDescription);
        } else {
            _demoVC.data = data;
            self.searchResults = [NSArray new];
        }
    }];
}

#pragma mark - SmileDemoChangeTempUnitsDelegate

-(void)changeTempUnitsToFahrenheit:(BOOL)isFahrenheit{
    NSLog(@"is now change to Fahrenheit -> %d", isFahrenheit);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
