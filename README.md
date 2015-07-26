# SmileWeather

A library for Search & Parse the weather data from Wunderground conveniently.

![](https://raw.githubusercontent.com/liu044100/SmileWeather/master/SmileWeather-Example/demo_gif/pro_big.png)

#What can it do for you?


##### 1. Handle all complicated things about Search & Parse the weather data.

For example, you can search place by using `-(void)getPlacemarksFromString:(NSString*)string completion:(SmileWeatherPlacemarksCompletion)completion`, the completion block return array of the `CLPlacemark`.

```
[[SmileWeatherDownLoader sharedDownloader] getPlacemarksForSearchDisplayFromString:@"cupertino" completion:^(NSArray *placeMarks, NSError *error) {
        if (!error) {
            //search results: array of placemark in here
        }
    }];
```

![](https://raw.githubusercontent.com/liu044100/SmileWeather/master/SmileWeather-Example/demo_gif/search.png)

You can get the placemark's weather data by using `-(void)getWeatherDataFromPlacemark:(CLPlacemark*)placeMark completion:(SmileWeatherDataDownloadCompletion)completion;`, the completion block return well formed weather data `SmileWeatherData`.

```
[[SmileWeatherDownLoader sharedDownloader] getWeatherDataFromPlacemark:placemark completion:^(SmileWeatherData *data, NSError *error) {
        if (!error) {
            //Well formed weather data in here.
        }
    }];
```


##### 2. Need not any weather icon, SmileWeather handle it for you. 

By using [climacons font](http://adamwhitcroft.com/climacons/), the `SmileWeatherData` contains the corresponding character that is used for weather icon.

```
SmileWeatherData *data = ...;
UILabel *iconLabel = ...;

//current weather condition
iconLabel.text = data.currentData.icon;
```

![](https://raw.githubusercontent.com/liu044100/SmileWeather/master/SmileWeather-Example/demo_gif/climacons.png)

##### 3. Fully localized the related information for almost all the countries in the world.

The weather information, timestamp, weekday, timezone, etc, localized all the related information as soon as possible.

![](https://raw.githubusercontent.com/liu044100/SmileWeather/master/SmileWeather-Example/demo_gif/localization.png)

#Theoretical Introduction

The main class is the `SmileWeatherDownLoader`. It handle downloading weather data from the [Wunderground](http://www.wunderground.com) server. It has three main method:

```
/*!Get weather data from CLPlacemark.*/
-(void)getWeatherDataFromPlacemark:(CLPlacemark*)placeMark completion:(SmileWeatherDataDownloadCompletion)completion;

/*!Get weather data from CLLocation.*/
-(void)getWeatherDataFromLocation:(CLLocation*)location completion:(SmileWeatherDataDownloadCompletion)completion;

/*!Get array of CLPlacemark from the input string.*/
-(void)getPlacemarksFromString:(NSString*)string completion:(SmileWeatherPlacemarksCompletion)completion;
```

In the `SmileWeatherDataDownloadCompletion` block, `SmileWeatherData` is returned, it contains the current weather data, 4 days forecast data, 24 hourly forecast data, etc. 

```
[[SmileWeatherDownLoader sharedDownloader] getWeatherDataFromPlacemark:placemark completion:^(SmileWeatherData *data, NSError *error) {
        if (!error) {
            NSLog(@"Current Temperature, Celsius : %@, Fahrenheit: %@", data.currentData.currentTempStri_Celsius, data.currentData.currentTempStri_Fahrenheit);
        }
    }];
```

#How to use it for your project?

**Step 1.** SmileWeather is available through use [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod 'SmileWeather'

```
Or you can drag the `SmileWeather` fold to your project.

**Step 2.** Sign up [Wunderground](http://www.wunderground.com/weather/api) to get the api key.
**Step 3.** Follow as the below image, add the api key and [climacons font](http://adamwhitcroft.com/climacons/) to your project's `Info.plist`. 

![](https://raw.githubusercontent.com/liu044100/SmileWeather/master/SmileWeather-Example/demo_gif/step1.png)

**Step 4.** Import `SmileWeatherDownLoader.h` to your class header file, and use it.



# Contributions

* Warmly welcome to submit a pull request.

# Contact

* If you have some advice or find some issue, please contact me.
* Email [me](liu044100@gmail.com)

# Thanks

Thanks for Comyar Zaheri's [Sol° for iOS](https://github.com/comyarzaheri/Sol), I am inspired by this project.

Thanks for [climacons font](http://adamwhitcroft.com/climacons/).

# License

SmileWeather is available under the MIT license. See the LICENSE file for more info.
