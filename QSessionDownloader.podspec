Pod::Spec.new do |s|
  s.name         = 'QSessionDownloader'
  s.version      = '1.0.2'
  s.ios.deployment_target = '7.0'
  s.license      = 'MIT'
  s.homepage     = 'https://github.com/QianChia/QSessionDownloader'
  s.authors      = {'QianChia' => 'jhqian0228@icloud.com'}
  s.summary      = 'A simple encapsulation of NSURLSession files to download'
  s.source       = {:git => 'https://github.com/QianChia/QSessionDownloader.git', :tag => s.version}
  s.source_files = 'QSessionDownloader'
  s.requires_arc = true
end
