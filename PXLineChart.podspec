
Pod::Spec.new do |s|


  s.name         = "PXLineChart"
  s.version      = "1.0.1"
  s.summary      = "一个简单的可左右滑动的折线走势图"
  s.homepage     = "https://github.com/PengXinabc/PXLineChart"

  s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             =  "彭欣" 
  s.platform     = :ios, "5.0"


  s.source       = { :git => "https://github.com/PengXinabc/PXLineChart.git", :tag => "#{s.version}" }

  s.source_files  = "PXLineChart/LineChart/*.{h,m}"

end
