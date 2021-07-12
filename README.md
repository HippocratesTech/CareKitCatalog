# OTFCareKitCatalog

This repository contains an app that catalogs many of the features and UI
components in the CareKit framework. It can serve as a useful reference for
designers and app developers who want to understand CareKit's design language
and the tools that are available to them.


# How to use in a project


User can install OTFCareKitCatalog using the cocoapod as shown below -

```
pod 'OTFCareKitCatalog'
```

It will install the OTFCareKitCatalog into your project. Now to launch the sample app from your test project, all you need to do is to import the framework first and then initialize the OTFCareKitCatalog inside the SceneDelegate class like shown below -


```
import OTFCareKitCatalog

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        if let window = window {
        let shared = OTFCareKitCatalog.shared
        shared.launchIn(window)
        }
        
    }

}
```
You can use above code if your project has a SceneDelegate class, and if you don't have a SceneDelegate, then you can simply use the App Delegate class to launch the sample app like this - 

```
    func application(_ application: UIApplication,      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
    
        if let window = window {
        let shared = OTFCareKitCatalog.shared
        shared.launchIn(self.window)
        }
    
        return true
    }
```

But before running the app, you also need to enable HealthKit capability under Signing & Capabilities of your project target. Along with it you need to add one privacy key into your project's plist file along with it's usage desciption.


```
Privacy - Health Share Usage Description

```


After doing these configurations, Now you can run your project and you should see the permission popup at first launch. If you don't see the popup, it could be due to previous failed authorization of HealthKit permision. In that case please delete the app and launch it again, and you should see the HealthKit permission popup this time. Allow all permissions and use the app.
