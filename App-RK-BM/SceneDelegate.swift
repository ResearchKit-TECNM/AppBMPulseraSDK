//
//  SceneDelegate.swift
//  App-RK-Wearable
//
//  Created by Luis Mora on 10/10/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print("sceneWillResignActive")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("sceneWillEnterForeground")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        print("sceneDidEnterBackground")

        // Guardar User
        
        // declarar el taskID para poder usarlo despues
        var taskID: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
        
        // intentar guardar el user en segundo plano de forma segura
        taskID = UIApplication.shared.beginBackgroundTask(withName: "saveUser") {
            // fin del tiempo en segundo plano, si el guardado aun no ha terminado
            UIApplication.shared.endBackgroundTask(taskID)
        }
        
        // llamada para guardar el user
        UserManager.shared.saveUser { succes in
            if succes {
                print("Guardado del user exitoso en segundo plano")
            } else {
                print("Error al guardar el user")
            }
            UIApplication.shared.endBackgroundTask(taskID)
        }
    }
}
