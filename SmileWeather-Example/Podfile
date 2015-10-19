platform :ios, '7.0'

target 'Smile Weather' do

pod 'SmileWeather', :path => "../"

#pod 'SmileWeather'

end

target 'SmileWeatherTodayWidget' do
    
pod 'SmileWeather', :path => "../"

#pod 'SmileWeather'

post_install do |installer|
    # NOTE: If you are using a CocoaPods version prior to 0.38, replace `pods_project` with `project` on the below line
    installer.pods_project.targets.each do |target|
        if target.name.end_with? "SmileWeather"
            target.build_configurations.each do |build_configuration|
                if build_configuration.build_settings['APPLICATION_EXTENSION_API_ONLY'] == 'YES'
                    build_configuration.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = ['$(inherited)', 'SmileWeather_APP_EXTENSIONS=1']
                end
            end
        end
    end
end
    
end

target 'SmileWeather-ExampleTests' do
pod 'SmileWeather', :path => "../"
#pod 'SmileWeather'
end

