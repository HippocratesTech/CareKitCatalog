//
//  OTFCareKitCatalog.swift
//  OTFCareKitCatalog
//
//  Created by Miroslav Kutak on 08/07/21.
//

import AuthenticationServices
import OTFCareKit
import OTFCareKitStore
import UIKit
import WatchConnectivity
import SwiftUI

public protocol OTFCareKitCatalogProtocol {
    func launchIn(_ window: UIWindow)
    var storeManager: OCKSynchronizedStoreManager { get set }
}

public class OTFCareKitCatalog: OTFCareKitCatalogProtocol {

    private(set) lazy var peer = OCKWatchConnectivityPeer()
    private(set) lazy var cdStore = OCKStore(name: "carekit-catalog-cd", type: .inMemory, remote: peer)
    #if HEALTH
    private(set) lazy var hkStore = OCKHealthKitPassthroughStore(store: cdStore)
    #endif

    private lazy var sessionManager: SessionManager = {
        let sessionManager = SessionManager()
        sessionManager.peer = self.peer
        sessionManager.store = self.cdStore
        return sessionManager
    }()

    lazy public var storeManager: OCKSynchronizedStoreManager = {

        cdStore.fillWithDummyData()
        #if HEALTH
        hkStore.fillWithDummyData()
        #endif

        let coordinator = OCKStoreCoordinator()
        coordinator.attach(store: cdStore)
        #if HEALTH
        coordinator.attach(eventStore: hkStore)
        #endif
        return OCKSynchronizedStoreManager(wrapping: coordinator)
    }()
    
    public static let shared: OTFCareKitCatalogProtocol = OTFCareKitCatalog()

    public func launchIn(_ window: UIWindow) {
        WCSession.default.delegate = sessionManager
        WCSession.default.activate()

        window.rootViewController = UIHostingController(rootView: CatalogView())
        window.tintColor = UIColor { $0.userInterfaceStyle == .light ? #colorLiteral(red: 0.9960784314, green: 0.3725490196, blue: 0.368627451, alpha: 1) : #colorLiteral(red: 0.8627432641, green: 0.2630574384, blue: 0.2592858295, alpha: 1) }
        window.makeKeyAndVisible()
    }

}

private class SessionManager: NSObject, WCSessionDelegate {

    fileprivate var peer: OCKWatchConnectivityPeer!
    fileprivate var store: OCKStore!

    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?) {

        print("WCSession activation did complete: \(activationState)")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession did become inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession did deactivate")
    }

    func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any],
        replyHandler: @escaping ([String: Any]) -> Void) {

        print("Did receive message!")

        peer.reply(to: message, store: store) { reply in
            replyHandler(reply)
        }
    }
}
