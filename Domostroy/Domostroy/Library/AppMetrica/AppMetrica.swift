//
//  AppMetrica.swift
//  Domostroy
//
//  Created by Игорь Пустыльник on 03.06.2025.
//

import AppMetricaCore

enum AnalyticsEvent {
    case appLaunch(loadTime: Double, authorized: Bool)
    case openRegistration
    case registrationCompleted
    case offerViewed(offerId: String, source: String)
    case offerAddedToFavorites(offerId: String)
    case rentRequestSubmitted(offerId: String)
    case offersLoaded(loadTime: Double, source: String)
    case calendarLoaded(loadTime: Double)

    var name: String {
        switch self {
        case .appLaunch: return "app_launch"
        case .openRegistration: return "open_registration"
        case .registrationCompleted: return "registration_completed"
        case .offerViewed: return "offer_viewed"
        case .offerAddedToFavorites: return "offer_added_to_favorites"
        case .rentRequestSubmitted: return "rent_request_submitted"
        case .offersLoaded: return "offers_loaded"
        case .calendarLoaded: return "calendar_loaded"
        }
    }

    var parameters: [AnyHashable: Any]? {
        switch self {
        case .offerViewed(let offerId, let source):
            return ["offer_id": offerId, "source": source]
        case .offerAddedToFavorites(let offerId):
            return ["offer_id": offerId]
        case .rentRequestSubmitted(let offerId):
            return ["offer_id": offerId]
        case .appLaunch(let loadTime, let authorized):
            return ["load_time": loadTime, "authorized": authorized]
        case .offersLoaded(let loadTime, let source):
            return ["load_time": loadTime, "source": source]
        case .calendarLoaded(let loadTime):
            return ["load_time": loadTime]
        default:
            return nil
        }
    }
}

extension AnalyticsEvent {
    func send(onFailure: ((Error) -> Void)? = nil) {
        guard !UIApplication.isDebuggerAttached() else {
            return
        }
        AppMetrica.reportEvent(name: self.name, parameters: self.parameters, onFailure: onFailure)
    }
}
