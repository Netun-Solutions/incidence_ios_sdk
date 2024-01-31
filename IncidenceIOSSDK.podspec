#
# Be sure to run `pod lib lint IncidenceLibraryIOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IncidenceIOSSDK'
  s.version          = '0.0.10'
  s.summary          = 'A short description of IncidenceIOSSDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'IncidenceIOSSDK.'

  s.homepage         = 'https://github.com/Netun-Solutions/incidence_ios_sdk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Netun-Solutions' => 'cconde@help-flash.com' }
  s.source           = { :git => 'https://github.com/Netun-Solutions/incidence_ios_sdk.git', :tag => 'v' +  s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  
  s.swift_version = '5.0'

  s.source_files = 'IncidenceLibraryIOS/Classes/**/*'
  
  #s.resource_bundles = {
  #    'IncidenceLibrary' => ['IncidenceLibrary/Assets/*.png']
  #    'IncidenceLibrary' => ['IncidenceLibrary/Classes/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}']
  #}
  
  #s.resource_bundles = {
  #    'IncidenceLibraryIOS' => ['IncidenceLibraryIOS/Assets/*.{png,json,jpeg,jpg,storyboard,xib,xcassets}']
  #}
  
  s.resources = 'IncidenceLibraryIOS/Assets/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,otf}'
  #s.resources = 'IncidenceLibrary/Classes/Presentation/Scenes/Development/DevelopmentScene.storyboard'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'Kingfisher'
  s.dependency 'Alamofire'
  # s.dependency 'Hue'
  # s.dependency 'youtube-ios-player-helper'
end
