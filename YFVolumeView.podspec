Pod::Spec.new do |s|

  s.name = "YFVolumeView"
  s.version = "1.0.0"
  s.summary = "Volume indicator as Indicator"

  s.homepage = "https://github.com/YuriFox/YFVolumeView/"
  s.license = { :type => "Apache License, Version 2.0'", :file => "LICENSE" }
  s.author = { "Yuri Fox" => "Yuri17fox@gmail.com" }
  s.source = { :git => "https://github.com/YuriFox/YFVolumeView.git", :tag => s.version.to_s}

  s.ios.deployment_target = '8.0'
  
  s.source_files = "Source/*.swift"

end
