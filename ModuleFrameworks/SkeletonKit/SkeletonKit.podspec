Pod::Spec.new do |spec|

  spec.name         = "SkeletonKit"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of SkeletonKit."
  spec.description  = <<-DESC
  					description
                   DESC

  spec.homepage     = "http://EXAMPLE/SkeletonKit"
  spec.license      = "MIT"
  spec.author             = { "Dimitar Valentinov Petrov" => "dimitar.petrov@upnetix.com" }
  spec.platform     = :ios, "10.0"
  spec.swift_version = '5.0'
  spec.source       = { :git => "", :tag => "" }
  spec.source_files  = "SkeletonKit", "SkeletonKit/**/*.{h,m,swift}"
  spec.exclude_files = "Classes/Exclude"

  spec.subspec 'Pods' do |pods|
    pods.source_files = 'Pods/**/*.{h,m,swift}'
  end

  spec.dependency 'LoggingKit', '~> 1.0.1'
  spec.dependency 'TwoWayBondage', '~> 1.0.2'
  spec.dependency 'UpnetixSystemAlertQueue', '~> 1.1.0'
  spec.dependency 'BaseKit', '~> 1.2.0'
  spec.dependency 'ActivityIndicatorManager', '~> 1.0.1'
   
end
