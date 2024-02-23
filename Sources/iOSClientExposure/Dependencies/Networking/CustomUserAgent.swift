import UIKit

public enum CustomUserAgent {
    public static let stringValue: String = {
        let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "-"
        let appVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "-"
        let osName = UIDevice.current.systemName
        let osVersionInfo = ProcessInfo.processInfo.operatingSystemVersion
        let osVersion = "\(osVersionInfo.majorVersion)_\(osVersionInfo.minorVersion)_\(osVersionInfo.patchVersion)"
        let cfNetworkBundle = Bundle(identifier: "com.apple.CFNetwork")
        let cfNetworkVersion = cfNetworkBundle?.infoDictionary?[kCFBundleVersionKey as String] as? String ?? "-"
        
        var components = [
            appName + "/" + appVersion,         // Serially/6752
            deviceIdentifier,                   // iPhone11,2
            osName + "/" + osVersion,           // iOS/17_3_1
            "CFNetwork/" + cfNetworkVersion,    // CFNetwork/1492.0.1
            "Darwin/" + darvinVersion,          // Darwin/23.3.0
        ]
        
        return components.joined(separator: " ")
    }()
    
    private static let darvinVersion: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.release)
        let darvinVersionString = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8,
                  value != 0 else {
                return identifier
            }
            
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return darvinVersionString
    }()
    
    private static let deviceIdentifier: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }()
}
