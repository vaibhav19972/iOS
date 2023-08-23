import UIKit

enum Screen {
    case contactList(token: String)
    case login
}

class RootCoordinator {
    static let shared = RootCoordinator()
    
    private var navigationController: UINavigationController!
    
    private init() {}
    
    func start(_ window: UIWindow) {
        guard self.navigationController == nil else {
            fatalError("Flow already started")
        }
        self.navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        moveTo(.login)
    }
    
    func moveTo(_ screen: Screen) {
        switch screen {
        case .contactList(let token):
            displaySecretViewController(token: token)
        case .login:
            displayLoginViewController()
        }
    }
    
    func displayPopup(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel)
        alertController.addAction(cancelAction)
        navigationController.visibleViewController?.present(alertController, animated: true)
    }
}

extension RootCoordinator {
    private func displaySecretViewController(token: String) {
        let contactTableViewController = contactTableViewController(token: token)
        navigationController.viewControllers = [contactTableViewController]
    }
    
    private func displayLoginViewController() {
        let loginViewController = LoginViewController()
        navigationController.viewControllers = [loginViewController]
    }
}
