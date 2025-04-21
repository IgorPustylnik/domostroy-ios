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

}
