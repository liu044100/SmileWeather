Pod::Spec.new do |s|
  s.name         = "SmileWeather"
  s.version      = "0.1.3"
  s.summary      = "A library for Search & Parse the weather data from Wunderground conveniently."
  s.description  = <<-DESC
                   1. Handle all complicated things about Search & Parse the weather data.
                   2. Need not any weather icon, SmileWeather handle it for you.
                   3. Fully localized the related information for almost all the countries in the world.
                   DESC

  s.homepage     = "https://github.com/liu044100/SmileWeather"
  s.screenshots  = "https://raw.githubusercontent.com/liu044100/SmileWeather/master/SmileWeather-Example/demo_gif/new_pro.jpg"
  s.license      = "MIT"

  s.author             = { 'Rain' => 'liu044100@gmail.com' }
  s.social_media_url   = "https://dribbble.com/yuchenliu"

  
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source       = { :git => "https://github.com/liu044100/SmileWeather.git", :tag => s.version.to_s}
  s.source_files  = 'SmileWeather/Classes/*'
  s.resources = ['SmileWeather/Assets/*.png', 'SmileWeather/Assets/*.ttf', 'SmileWeather/Assets/*.xib']
  s.public_header_files = 'SmileWeather/Classes/*.h'
  s.frameworks = 'UIKit', 'CoreLocation'

end
