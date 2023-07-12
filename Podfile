# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'RxMoneyManager' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxDataSources'
  pod 'RxGesture'
  pod 'SnapKit'
  pod 'SamUtils', :path => '/Users/si1302/Desktop/iOS/SamUtils/'
  pod 'RealmSwift'
  pod 'R.swift'
  pod 'DGCharts'

  # Pods for RxMoneyManager
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        end
      end
    end

end
