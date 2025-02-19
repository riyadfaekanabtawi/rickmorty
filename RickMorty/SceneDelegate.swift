//
//  SceneDelegate.swift
//  RickMorty
//
//  Created by Riyad Anabtawi on 12/02/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController(rootViewController: CharacterListViewController())

        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
