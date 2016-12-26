Pod::Spec.new do |s|
  s.name = 'PIPContainer'
  s.version = '1.0.0'
  s.summary = 'An easy to use interface for picture-in-picture on macOS 10.12 and later.'
  s.homepage = 'https://github.com/insidegui/PIPContainer'
  s.description = 'A view controller subclass to contain other view controllers to be presented in picture-in-picture mode'

  s.license =  { :type => 'BSD' }
  s.authors = 'Guilherme Rambo'
  s.social_media_url = 'https://twitter.com/_inside'
  s.source = {
    :git => 'https://github.com/insidegui/PIPContainer.git',
    :tag => s.version.to_s,
    :branch => 'master'
  }
  
  s.osx.source_files = 'Sources/**/*.{h,m}'
  s.osx.private_header_files = 'Sources/Private/*.h'
  s.osx.deployment_target = '10.12'
  
  s.requires_arc = true
  
  s.xcconfig = {'FRAMEWORK_SEARCH_PATHS' => '/System/Library/PrivateFrameworks'}
  s.osx.frameworks = ['Cocoa', 'PIP']
end
