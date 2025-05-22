//
//  
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupServices()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

}

// MARK: - Private methods

private extension AppDelegate {
    func setupServices() {
        let basicStorage: BasicStorage = BasicUserDefaultsStorage()
        let secureStorage: SecureStorage = SecureKeychainStorage()
        ServiceLocator.shared.register(service: basicStorage as BasicStorage)
        ServiceLocator.shared.register(service: secureStorage as SecureStorage)
        ServiceLocator.shared.register(service: AuthNetworkService() as AuthService)
        ServiceLocator.shared.register(service: AdminNetworkService(secureStorage: secureStorage) as AdminService)
        ServiceLocator.shared.register(service: OfferNetworkService(secureStorage: secureStorage) as OfferService)
        ServiceLocator.shared.register(service: RentNetworkService(secureStorage: secureStorage) as RentService)
        ServiceLocator.shared.register(service: CityNetworkService(secureStorage: secureStorage) as CityService)
        ServiceLocator.shared.register(service: CategoryNetworkService(secureStorage: secureStorage) as CategoryService)
        ServiceLocator.shared.register(service: UserNetworkService(secureStorage: secureStorage) as UserService)
    }
}
