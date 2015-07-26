Pod::Spec.new do |s|
  s.name         = "SmileWeather"
  s.version      = "0.0.1"
  s.summary      = "A Library for weather conveniently"
  s.description  = <<-DESC
                   1. Handle all complicated things about weather.
                   2. Get elegant animation automatically and adaptive UI.
                   3. Support iOS7 and later.
                   DESC

  s.homepage     = "https://github.com/liu044100/SmileWeather"
  s.screenshots  = "https://raw.githubusercontent.com/liu044100/SmileTouchID/master/Example/demo_gif/demo1.gif", "https://raw.githubusercontent.com/liu044100/SmileTouchID/master/Example/demo_gif/demo2.gif"
  s.license      = "MIT"

  s.author             = { 'Rain' => 'liu044100@gmail.com' }
  s.social_media_url   = "https://dribbble.com/yuchenliu"

  
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source       = { :git => "https://github.com/liu044100/SmileWeather.git", :tag => s.version.to_s}
  s.source_files  = 'SmileWeather/Classes/*'
  s.resource = ['SmileWeather/Assets/*']
  s.public_header_files = 'SmileWeather/Classes/*.h'
  s.frameworks = 'UIKit'

end
