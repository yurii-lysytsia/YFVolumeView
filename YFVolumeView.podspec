Pod::Spec.new do |s|

  # 1
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name = "YFVolumeView"
  s.summary = "Volume indicator as Indicator"
  s.requires_arc = true

  # 2
  s.version = "1.0"

  # 3
  s.license = { :type => "Apache License, Version 2.0'", :file => "LICENSE" }

  # 4 - Replace with your name and e-mail address
  s.author = { "Yuri Fox" => "Yuri17fox@gmail.com" }

  # 5 - Replace this URL with your own Github page's URL (from the address bar)
  s.homepage = "https://github.com/YuriFox/YFVolumeView/"

  # 6 - Replace this URL with your own Git URL from "Quick Setup"
  s.source = { :git => "https://github.com/YuriFox/YFVolumeView.git", :tag => "#{s.version}"}

  # 7
  # s.framework = "UIKit"

  # 8
  s.source_files = "Source/*.{swift}"

end
