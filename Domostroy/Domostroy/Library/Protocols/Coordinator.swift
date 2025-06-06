//
//  
//

import Foundation

/// Base protocol for coordinator
protocol Coordinator: AnyObject {
    /// Notifies coordinator that it can start itself
    func start()
    /// Notifies coordinator that it should start itself with deeplink option
    ///
    /// - parameter deepLinkOption: deeplink option such as Dynamic Link, push-notification, etc.
    func start(with deepLinkOption: DeepLinkOption?)
    /// Notifies coordinator that it should remove all child coordinators
    func removeAllChildren()
}
