import UIKit

// Enum to represent different screens in the app
enum Screen {
    case secret(token: String)
    case landing
    case login
}

class RootCoordinator {
    // Singleton instance
    static let shared = RootCoordinator()
    
    private var navigationController: UINavigationController!
    
    // Private initializer for singleton
    private init() {}
    
    // Start the app flow
    func start(_ window: UIWindow) {
        // Ensure that the flow has not already started
        guard self.navigationController == nil else {
            fatalError("Flow already started")
        }
        
        // Create a navigation controller as the root
        self.navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        // Start at the landing screen
        moveTo(.landing)
    }
    
    // Navigate to a specific screen
    func moveTo(_ screen: Screen) {
        switch screen {
        case .secret(let token):
            displaySecretViewController(token: token)
        case .landing:
            if UserDefaults.standard.bool(forKey: "isLoggedIn") {
                // User is logged in, show secret screen
                let token = UserDefaults.standard.string(forKey: "userToken") ?? ""
                displaySecretViewController(token: token)
            } else {
                // User is not logged in, show landing screen
                displayLandingViewController()
            }
        case .login:
            // Show login screen
            displayLoginViewController()
        }
    }
    
    // Display a popup with a title and optional message
    func displayPopup(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cancelAction)
        navigationController.visibleViewController?.present(alertController, animated: true)
    }
}

extension RootCoordinator {
    // Display the secret screen with a token
    private func displaySecretViewController(token: String) {
        let secretViewController = SecretViewController(token: token)
        navigationController.viewControllers = [secretViewController]
    }
    
    // Display the landing screen
    private func displayLandingViewController() {
        let landingViewController = LandingViewController()
        navigationController.viewControllers = [landingViewController]
    }
    
    // Display the login screen
    private func displayLoginViewController() {
        let loginViewController = LoginViewController()
        navigationController.popViewController(animated: true)
        navigationController.pushViewController(loginViewController, animated: true)
    }
}
