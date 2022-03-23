Pod::Spec.new do |spec|
spec.name         = "iOSClientExposure"
spec.version      = "3.0.000"
spec.summary      = "RedBeeMedia iOS SDK Exposure Module"
spec.homepage     = "https://github.com/EricssonBroadcastServices"
spec.license      = { :type => "Apache", :file => "https://github.com/EricssonBroadcastServices/iOSClientExposure/blob/master/LICENSE" }
spec.author             = { "EMP" => "jenkinsredbee@gmail.com" }
spec.documentation_url = "https://github.com/EricssonBroadcastServices/iOSClientExposure/tree/master/Documentation"
spec.platforms = { :ios => "9.0", :tvos => "9.0" }
spec.swift_version = "5.0"
spec.source       = { :git => "https://github.com/EricssonBroadcastServices/iOSClientExposure.git", :tag => "v#{spec.version}" }
spec.source_files  = "Sources/iOSClientExposure/**/*.swift"
spec.xcconfig = { "SWIFT_VERSION" => "5.0" }
end
