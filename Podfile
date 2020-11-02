source 'https://github.com/CocoaPods/Specs.git'
source 'https://bitbucket.scalefocus.com/scm/il/podspecrepo.git'

# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'SetupProject' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  # ignore all warnings from all pods
  inhibit_all_warnings!

  # Pods for SetupProject
  pod 'SwiftLint', '~> 0.40.3'
  pod 'SFLoggingKit', '~> 1.0.3'
  pod 'SFBaseKit'
  pod 'NetworkKit'                     , :path => 'ModuleFrameworks/NetworkKit'
  pod 'UpnetixLocalizer', '2.1.3'
  pod 'UpnetixSystemAlertQueue', '~> 1.2.0'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if ['CryptoSwift'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.2'
            end
        end
    end
end
