//
//  
//

import UIKit

extension UIApplication {

    class func topWindow() -> UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })
    }

    class func topViewController(
        _ controller: UIViewController? = topWindow()?.rootViewController
    ) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            return tabController.selectedViewController.flatMap { topViewController($0) }
        }
        if let presentedController = controller?.presentedViewController {
            return topViewController(presentedController)
        }
        return controller
    }

    static func appVersion() -> String? {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        return appVersion
    }

    static func isDebuggerAttached() -> Bool {
        var info = kinfo_proc()
        var size = MemoryLayout<kinfo_proc>.size
        var name: [Int32] = [
            CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()
        ]

        let result = name.withUnsafeMutableBufferPointer { (namePointer) -> Bool in
            return sysctl(namePointer.baseAddress, 4, &info, &size, nil, 0) == 0
        }

        return result && (info.kp_proc.p_flag & P_TRACED) != 0
    }

}
