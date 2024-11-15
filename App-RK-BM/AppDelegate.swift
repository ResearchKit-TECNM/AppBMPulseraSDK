//
//  AppDelegate.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 10/10/24.
//

import UIKit
import ResearchKitActiveTask
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let dispatchGroup = DispatchGroup()
    var isUserLoaded: Bool = false

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        lockApp()
        
        FirebaseApp.configure()
        
        // configura Google Sign IN
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                print("Error al restaurar la sesión anterior: \(error.localizedDescription)")
                return
            }
            if let user = user {
                print("Usuario autenticado: \(user.profile?.name ?? "")")
            }
        }
        
        // cargar user
        dispatchGroup.enter()
        Auth.auth().addStateDidChangeListener { auth, user in
            guard !self.isUserLoaded else { return } // salir si ya se cargo el user
            self.isUserLoaded = true // cambiar la bandera si no se ha cargado el user
            
            if let currentUser = user {
                UserManager.shared.loadUser(uid:  currentUser.uid) { result in
                    switch result {
                    case .success(let user):
                        print("AppDelegate: Usuario cargado exitosamente: \(user)")
                        // notificar a la interfaz de la cara del user
                        NotificationCenter.default.post(name: Notification.Name("UserLoaded"), object: nil)
                    case .failure(let error):
                        print("AppDelegate: Error al cargar el usuario: \(error)")
                    }
                    // Salir del grupo una vez que se completa la carga del usuario
                    self.dispatchGroup.leave()
                }
            } else {
                print("No hay usuario autenticado a través de Google.")
                // Manejar el caso donde no hay usuario
                self.dispatchGroup.leave()
            }
        }
        
        return true
    }
    
    private func loadUser(uid: String) {
        dispatchGroup.enter() // Entrar en el grupo

        UserManager.shared.loadUser(uid: uid) { result in
            switch result {
            case .success(let user):
                print("AppDelegate: Usuario cargado exitosamente: \(user)")
            case .failure(let error):
                print("AppDelegate: Error al cargar el usuario: \(error)")
            }
            self.dispatchGroup.leave() // Asegúrate de que esto se llama
        }

        // Esperar hasta que se complete la carga del usuario
        dispatchGroup.notify(queue: .main) {
            print("AppDelegate: Firebase y usuario listos.")
        }
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func lockApp() {
        /*
         * Only lock the app if there is a stored passcode and a passcode
         * controller isn't already being shown.
         */
        guard ORKPasscodeViewController.isPasscodeStoredInKeychain() && !(containerViewController?.presentedViewController is ORKPasscodeViewController) else { return }
            
        window?.makeKeyAndVisible()
            
        let passcodeViewController = ORKPasscodeViewController.passcodeAuthenticationViewController(withText: "Welcome back ", delegate: self)
        containerViewController?.present(passcodeViewController, animated: false, completion: nil)
    }
    
    var containerViewController: IntroViewController? {
        return window?.rootViewController as? IntroViewController
    }

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let standardDefaults = UserDefaults.standard
        if standardDefaults.object(forKey: "TutorialFirstRun") == nil {
            ORKPasscodeViewController.removePasscodeFromKeychain()
            standardDefaults.setValue("TutorialFirstRun", forKey: "TutorialFirstRun")
        }
            
        // Appearance customization
        let pageControlAppearance = UIPageControl.appearance()
        pageControlAppearance.pageIndicatorTintColor = UIColor.lightGray
        pageControlAppearance.currentPageIndicatorTintColor = UIColor.black
            
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if ORKPasscodeViewController.isPasscodeStoredInKeychain() {
            // Hide content so it doesn't appear in the app switcher.
            containerViewController?.contentHidden = true
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        lockApp()
    }
    
    // configuracion inicial de autenticación
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    // Método llamado cuando la aplicación está a punto de ir al fondo
    func applicationWillResignActive(_ application: UIApplication) {
    }

}

extension AppDelegate: ORKPasscodeDelegate {
    func passcodeViewControllerDidFinish(withSuccess viewController: UIViewController) {
        containerViewController?.contentHidden = false
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func passcodeViewControllerDidFailAuthentication(_ viewController: UIViewController) {
    }
}
