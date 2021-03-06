//
//  AppDelegate.swift
//  askUSC
//
//  Created by Boyuan Xu on 10/14/18.
//  Copyright © 2018 Boyuan Xu. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import UIWindowTransitions
import SideMenu
import SwiftLocation
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    // MARK: Google Sign-in function
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
        } /*else if !user.profile.email.contains("usc.edu") {
            print("Not USC email!")
            GIDSignIn.sharedInstance()?.signOut()
            (SharedInfo.currentRootViewController as? LoginViewController)?.notUSCEmail()
        }*/ else {
            guard let authentication = user.authentication else { return }
            // Setting CoreInformation
            CoreInformation.shared.setUserID(ID: user.userID, isFirebase: false)
            CoreInformation.shared.setFullName(name: user.profile.name)
            CoreInformation.shared.setName(setFirst: true, name: user.profile.givenName)
            CoreInformation.shared.setName(setFirst: false, name: user.profile.familyName)
            CoreInformation.shared.setEmail(email: user.profile.email)
            
            // Logging in to Firebase with Google Auth
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            Auth.auth().signInAndRetrieveData(with: credential) { [unowned self] (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    GIDSignIn.sharedInstance()?.signOut()
                    self.window?.setWithAnimation(rootViewController: LoginViewController(), with: .fade)
                    self.window?.makeKeyAndVisible()
                    return
                }
                self.loginSetup(user: user)
                print(result?.user.email ?? "Null email")
            }
            DiskManager.shared.readMessagesFromDisk()
        }
    }
    
    func loginSetup(user: GIDGoogleUser) {
        // Setting root controller to HomeViewController wrapped inside a UINavigationController, forever leaving the login screen behind!
        // MARK: Setting Firebase userID in CoreInformation
        CoreInformation.shared.setUserID(ID: (Auth.auth().currentUser?.uid)!, isFirebase: true)
        FirebaseUtility.shared.saveUserToDatabaseIfNotExists(user: CoreInformation.shared.getUserObject()) { [unowned self] (error) in
            if let error = error {
                self.window?.rootViewController?.generalFailureAlert(message: error, completion: {
                    try? Auth.auth().signOut()
                    GIDSignIn.sharedInstance()?.signOut()
                    return
                })
            }
            // MARK: Side Menu init
            self.sideMenuInit()
            self.homeVC = ProfileViewController()
            self.navigationController = UINavigationController(rootViewController: self.homeVC!)
            self.window?.setWithAnimation(rootViewController: self.navigationController!, with: nil)
            SharedInfo.currentRootViewController = self.homeVC!
            SharedInfo.currentNavController = self.navigationController!
            self.window?.makeKeyAndVisible()
        }
    }
    
    // MARK: What to do when user disconnects from Google session
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("User disconnected")
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return (GIDSignIn.sharedInstance()?.handle(url as URL?, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation]))!
    }
    
    // MARK: Side Menu setup
    func sideMenuInit() {
        sideMenuNavController = UISideMenuNavigationController(rootViewController: SideMenuTableViewController())
        SideMenuManager.default.menuLeftNavigationController = sideMenuNavController
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
    var window: UIWindow?
    var sideMenuNavController: UISideMenuNavigationController?
    var navigationController: UINavigationController?
    var homeVC: ProfileViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // MARK: Injection
//        #if DEBUG
//        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection10.bundle")?.load()
//        #endif
        
        // MARK: Firebase
        FirebaseApp.configure()
        let db = Firestore.firestore()
        let settings = db.settings
        db.settings = settings
        
        // MARK: Register attributed string styles
        StringStyleRegistry.shared.register()
        
        // MARK: Enabling IQKeyboardManager
        IQKeyboardManager.shared.enable = true
        
        // MARK: Google Sign-in configuration
        GIDSignIn.sharedInstance()?.clientID = "253962125312-pi790mc56ulpq3rke03vm5ct4t0a72ed.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.delegate = self
        
        // MARK: Making a new window for the application since Storyboard isn't used.
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            // If the user is already signed in, skip the login screen.
            if (GIDSignIn.sharedInstance()?.hasAuthInKeychain())! {
                GIDSignIn.sharedInstance()?.signInSilently()
            } else {
                window.rootViewController = LoginViewController()
                window.makeKeyAndVisible()
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if let window = window {
            // If the user is already signed in, skip the login screen.
            if Auth.auth().currentUser == nil {
                GIDSignIn.sharedInstance()?.signOut()
                window.setWithAnimation(rootViewController: LoginViewController(), with: nil)
                window.makeKeyAndVisible()
            }
        }
        DiskManager.shared.readMessagesFromDisk()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        if (CoreInformation.shared.getName(getFirst: true) == "Guest") {
            DiskManager.shared.deleteAllMessages()
        }
    }
}

