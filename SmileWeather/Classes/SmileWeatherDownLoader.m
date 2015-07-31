//
//  SmileWeatherDownLoader.m
//  SmileWeather-Example
//
//  Created by ryu-ushin on 7/13/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmileWeatherDownLoader.h"

#define INFO_DIC @"SmileWeather"
#define API_NOW  @"API_NOW"
#define API_KEY_wunderground @"API_KEY_wunderground"
#define API_KEY_openweathermap @"API_KEY_openweathermap"

@interface SmileWeatherDownLoader()
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, readwrite) SmileWeatherAPI weatherAPI;

//download
@property (nonatomic, strong) NSURLSession *session;

//for search display
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, copy) NSString *lastSearchString;
@end

@implementation SmileWeatherDownLoader

+(NSDictionary*)smileWeatherInfoDic{
    NSDictionary *dic = [[SmileWeatherDownLoader appInfoPlist]  objectForKey:INFO_DIC];
    NSAssert(dic != nil, @"Please add SmileWeather key to your Info.plist");
    return dic;
}

+(NSDictionary*)appInfoPlist{
    static dispatch_once_t onceToken;
    static NSDictionary *_sharedInstance;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[NSBundle mainBundle] infoDictionary];
    });
    return _sharedInstance;
}

-(instancetype)initFromInfoKey:(NSDictionary*)smileInfo{
    SmileWeatherDownLoader *sharedDownloader;
    if ([smileInfo[API_NOW] isKindOfClass:[NSNumber class]]) {
        NSNumber *api_now = smileInfo[API_NOW];
        sharedDownloader = [[SmileWeatherDownLoader alloc]initWithAPIType:(SmileWeatherAPI)[api_now intValue]];
    } else {
        NSString *apikey_wunderground = smileInfo[API_KEY_wunderground];
        NSString *apikey_openweathermap = smileInfo[API_KEY_openweathermap];
        if (apikey_wunderground && !apikey_openweathermap) {
            sharedDownloader = [[SmileWeatherDownLoader alloc] initWithWundergroundAPIKey:apikey_wunderground];
        } else if (!apikey_wunderground && apikey_openweathermap){
            sharedDownloader = [[SmileWeatherDownLoader alloc] initWithOpenweathermapAPIKey:apikey_openweathermap];
        } else {
            NSAssert( apikey_wunderground != nil && apikey_openweathermap !=nil, @"No Wunderground or Openweathermap key to your Info.plist");
            
            NSAssert( apikey_wunderground == nil && apikey_openweathermap ==nil, @"Both of Wunderground and Openweathermap key in your Info.plist, please add API_NOW key to select which one is used.");
        }
    }
    
    return sharedDownloader;
}

+(SmileWeatherDownLoader*)sharedDownloader {
    static SmileWeatherDownLoader *sharedDownloader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *smileInfo =  [SmileWeatherDownLoader smileWeatherInfoDic];
        sharedDownloader = [[SmileWeatherDownLoader alloc] initFromInfoKey:smileInfo];
    });
    return sharedDownloader;
}

- (instancetype)initWithWundergroundAPIKey:(NSString*)apikey{
    if(self = [super init]) {
        self.weatherAPI = API_wunderground;
        self.key = apikey;
        self.geocoder = [[CLGeocoder alloc]init];
        self.session = [NSURLSession sharedSession];
    }
    return self;
}

- (instancetype)initWithOpenweathermapAPIKey:(NSString*)apikey{
    if(self = [super init]) {
        self.weatherAPI = API_openweathermap;
        self.key = apikey;
        self.geocoder = [[CLGeocoder alloc]init];
        self.session = [NSURLSession sharedSession];
    }
    return self;
}


- (instancetype)initWithAPIType:(SmileWeatherAPI)type
{
    if(self = [super init]) {
        self.weatherAPI = type;
        NSDictionary *smileInfo =  [SmileWeatherDownLoader smileWeatherInfoDic];
        NSString *apikey;
        if (self.weatherAPI == API_wunderground) {
            apikey = smileInfo[API_KEY_wunderground];
            NSAssert(apikey != nil, @"Please add Wunderground key to your Info.plist");
            self = [[SmileWeatherDownLoader alloc] initWithWundergroundAPIKey:apikey];
        } else if (self.weatherAPI == API_openweathermap){
            apikey = smileInfo[API_KEY_openweathermap];
            NSAssert(apikey != nil, @"Please add openweathermap key to your Info.plist");
            self = [[SmileWeatherDownLoader alloc] initWithOpenweathermapAPIKey:apikey];
        }
    }
    return self;
}

#pragma mark - download weather data

-(void)getWeatherRawDicFromURL:(NSURL *)url completion:(SmileWeatherRawDicCompletion)completion{
    if (!url | !completion) {
        NSLog(@"invalid url or completion");
        return;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dataDic;
        if (!error) {
            dataDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        }
        SmileWeather_DispatchMainThread(^(){
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            completion(dataDic, error);
        });
    }];
    [dataTask resume];
}

-(void)getWeatherRawDataFromURL:(NSURL *)url completion:(SmileWeatherRawDataCompletion)completion{
    if (!url | !completion) {
        NSLog(@"invalid url or completion");
        return;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        SmileWeather_DispatchMainThread(^(){
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            completion(data, error);
        });
    }];
    [dataTask resume];
}

-(void)getWeatherDataFromPlacemark:(CLPlacemark *)placeMark completion:(SmileWeatherDataDownloadCompletion)completion {
    
    if (!placeMark | !completion) {
        NSLog(@"invalid location or completion");
        return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if (self.weatherAPI == API_wunderground) {
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:[self urlForLocation:placeMark.location] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            SmileWeatherData *weatherData;
            
            if (!error) {
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                weatherData = [[SmileWeatherData alloc] initWithJSON:dataDic inPlacemark:placeMark];
                //                NSLog(@"raw data -> %@", dataDic);
            }
            SmileWeather_DispatchMainThread(^(){
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                completion(weatherData, error);
            });
            
        }];
        
        [dataTask resume];
    }
    
    else if (self.weatherAPI == API_openweathermap){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            __block NSMutableDictionary *allDataDic = [NSMutableDictionary new];
            __block SmileWeatherData *weatherData;
            __block NSError *allError;
            
            dispatch_group_t downloadGroup = dispatch_group_create();
            
            NSArray *urlArrays = @[[self urlForCurrentDataInLocation:placeMark.location], [self urlForForecastDataInLocation:placeMark.location]];
            
            for (NSURL *url in urlArrays) {
                
                dispatch_group_enter(downloadGroup);
                
                NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    if (!error) {
                        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                        [allDataDic addEntriesFromDictionary:dataDic];
                    }else{
                        allError = error;
                    }
                    
                    dispatch_group_leave(downloadGroup);
                    
                }];
                
                [dataTask resume];
                
            }
            
            dispatch_group_wait(downloadGroup, DISPATCH_TIME_FOREVER);
            
            if (!allError) {
                weatherData = [[SmileWeatherData alloc] initWithJSON:allDataDic inPlacemark:placeMark];
                //                NSLog(@"openweathermap -> raw data -> %@", allDataDic);
            }
            
            SmileWeather_DispatchMainThread(^(){
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                completion(weatherData, allError);
            });
            
            
        });
    }
}
-(void)getWeatherDataFromLocation:(CLLocation*)location completion:(SmileWeatherDataDownloadCompletion)completion {
    if (!location | !completion) {
        NSLog(@"invalid location or completion");
        return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self.geocoder reverseGeocodeLocation:location completionHandler: ^(NSArray *placemarks, NSError *error) {
        if(placemarks.count > 0) {
            CLPlacemark *placeMark = [placemarks lastObject];
            [self getWeatherDataFromPlacemark:placeMark completion:completion];
        } else if(error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            completion(nil, error);
        }
    }];
}

#pragma mark - Placemarks List

-(void)getPlacemarksFromString:(NSString *)string completion:(SmileWeatherPlacemarksCompletion)completion {
    [self.geocoder cancelGeocode];
    [self.geocoder geocodeAddressString:string completionHandler:^(NSArray *placemarks, NSError *error) {
        NSMutableArray *availablePlacemarks = [NSMutableArray new];
        
        for (int i = 0; i < placemarks.count; i++) {
            CLPlacemark *placemark = placemarks[placemarks.count - 1 - i];
            if ([SmileWeatherDownLoader availablePlacemark:placemark]) {
                [availablePlacemarks insertObject:placemark atIndex:0];
            }
        }
        completion([NSArray arrayWithArray:availablePlacemarks], error);
    }];
}

-(void)getPlacemarksForSearchDisplayFromString:(NSString *)string completion:(SmileWeatherPlacemarksCompletion)completion{
    
    if (!self.searchResults) {
        self.searchResults = [NSMutableArray new];
    }
    
    __block BOOL isDelete;
    
    if (!self.lastSearchString) {
        self.lastSearchString = string;
    } else {
        isDelete = self.lastSearchString.length > string.length;
        self.lastSearchString = string;
    }
    
    
    if (string.length == 0) {
        [self.searchResults removeAllObjects];
    } else {
        [self getPlacemarksFromString:string completion:^(NSArray *placeMarks, NSError *error) {
            
            if (isDelete) {
                completion(placeMarks, error);
                return;
            }
            
            NSMutableArray *allArray = [self.searchResults mutableCopy];
            NSMutableArray *arrayToDelete = [NSMutableArray new];
            
            for(CLPlacemark *placemark in placeMarks) {
                    for(CLPlacemark *inplacemark in allArray) {
                        if (inplacemark.location.coordinate.latitude == placemark.location.coordinate.latitude && inplacemark.location.coordinate.longitude == placemark.location.coordinate.longitude) {
                            [arrayToDelete addObject:placemark];
                        }
                    }
                    [self.searchResults insertObject:placemark atIndex:0];
            }
            
            [self.searchResults removeObjectsInArray:arrayToDelete];
            
            
            completion([NSArray arrayWithArray:self.searchResults], error);
        }];
    }
}

#pragma mark - Utility

-(NSString *)preferedLanguage{
    NSString *lang = [[NSLocale preferredLanguages] objectAtIndex:0];
    if (self.weatherAPI == API_wunderground) {
        NSDictionary *langCodes = @{
                                    @"es": @"SP",
                                    @"ko_KR" : @"KR",
                                    @"ja" : @"JP",
                                    @"ja_JP" : @"JP",
                                    @"zh-Hans" : @"CN",
                                    @"zh-Hant" : @"TW",
                                    };
        NSString *l = [langCodes objectForKey:lang];
        if (l) {
            lang = l;
        }else {
            lang = [lang uppercaseString];
        }
        
        
    } else if (self.weatherAPI == API_openweathermap){
        NSDictionary *langCodes = @{
                                    @"en-GB": @"en",
                                    @"pt-PT" : @"pt",
                                    @"zh-Hans" : @"zh_cn",
                                    @"zh-Hant" : @"zh_tw",
                                    };
        NSString *l = [langCodes objectForKey:lang];
        if (l) {
            lang = l;
        }
    }
    
    return lang;
}

+(BOOL)availablePlacemark:(CLPlacemark*)placemark{
    if (placemark.locality) {
        return YES;
    }
    if (!placemark.locality && !placemark.administrativeArea) {
        return NO;
    } else {
        return YES;
    }
}

+(NSString *)placeNameForDisplay:(CLPlacemark *)placemark{
//    NSLog(@"%@",[SmileWeatherDownLoader infoFromPlacemark_DEBUG:placemark]);
    
    NSMutableString *address = [[NSMutableString alloc] init];
    
    if (placemark.locality) {
        [address appendString:placemark.locality];
    } else {
        if (placemark.name) {
            [address appendString:placemark.name];
        }
    }
    
    return [NSString stringWithString:address];
}

+(NSString *)placeNameForSearchDisplay:(CLPlacemark *)placemark{
    NSMutableString *address = [[NSMutableString alloc] init];
    
    if (![placemark.name isEqualToString:placemark.locality] && ![placemark.name isEqualToString:placemark.administrativeArea]) {
        [address appendString:placemark.name];
    }
    
    if (placemark.locality) {
        if ([address isEqualToString:@""]||[address isEqual:nil] ) {
            [address appendString:placemark.locality];
        }
        else{
            NSString *strtemp=[NSString stringWithFormat:@", %@",placemark.locality];
            [address appendString:strtemp];
        }
    }
    if (placemark.administrativeArea) {
        if ([address isEqualToString:@""]||[address isEqual:nil] ) {
            [address appendString:placemark.administrativeArea];
        }
        else{
            NSString *strtemp=[NSString stringWithFormat:@", %@",placemark.administrativeArea];
            [address appendString:strtemp];
        }
    }
    if (placemark.country) {
        if ([address isEqualToString:@""]||[address isEqual:nil] ) {
            [address appendString:placemark.country];
        }
        else{
            NSString *strtemp=[NSString stringWithFormat:@", %@",placemark.country];
            [address appendString:strtemp];
        }
    }
    
    return [NSString stringWithString:address];
}

//url for openweathermap current weather
-(NSURL*)urlForCurrentDataInLocation:(CLLocation*)location{
    return [self urlFor:@"weather" inLocation:location];
}

//url for openweathermap forecast
-(NSURL*)urlForForecastDataInLocation:(CLLocation*)location{
    
    return [self urlFor:@"forecast" inLocation:location];
}

-(NSURL*)urlFor:(NSString*)type inLocation:(CLLocation*)location{
    /*
     API key
     api.openweathermap.org/data/2.5/forecast/city?id=524901&APPID=1111111111
     
     Current weather data
     api.openweathermap.org/data/2.5/weather?lat=35&lon=139
     
     Forecast weather data
     api.openweathermap.org/data/2.5/forecast?lat=35&lon=139
     */
    NSString *requestURL;
    static NSString *baseURL_openweathermap =  @"http://api.openweathermap.org/data/2.5";
    NSString *parameters_openweathermap = [NSString stringWithFormat:@"/%@?", type];
    CLLocationCoordinate2D coordinates = location.coordinate;
    requestURL = [NSString stringWithFormat:@"%@%@lat=%f&lon=%f&APPID=%@&lang=%@", baseURL_openweathermap, parameters_openweathermap, coordinates.latitude, coordinates.longitude, self.key, [self preferedLanguage]];
    
//    NSLog(@"openweathermap -> url type -> %@ -> %@", type, requestURL);
    
    NSURL *url = [NSURL URLWithString:requestURL];
    
    return url;
}

//url for wunderground
-(NSURL*)urlForLocation:(CLLocation *)location {
    
    NSString *requestURL;
    
    NSString *lang = [[SmileWeatherDownLoader sharedDownloader] preferedLanguage];
    
    static NSString *baseURL_wunderground =  @"http://api.wunderground.com/api/";
    NSString *parameters_wunderground = [NSString stringWithFormat:@"/forecast/conditions/astronomy/hourly/lang:%@/q/",lang];
    CLLocationCoordinate2D coordinates = location.coordinate;
    requestURL = [NSString stringWithFormat:@"%@%@%@%f,%f.json", baseURL_wunderground, self.key, parameters_wunderground, coordinates.latitude, coordinates.longitude];
    
//    NSLog(@"wunderground url -> %@", requestURL);
    
    NSURL *url = [NSURL URLWithString:requestURL];
    
    return url;
}

#pragma mark - Debug Utility

+(NSString*)infoFromPlacemark_DEBUG:(CLPlacemark*)placemark {
    NSString *info = [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@, %@, %@, %@", placemark.name, placemark.locality, placemark.subLocality, placemark.administrativeArea, placemark.subAdministrativeArea, placemark.thoroughfare, placemark.subThoroughfare, placemark.region, placemark.country];
    return info;
}

@end
