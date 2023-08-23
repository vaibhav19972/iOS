import UIKit

@objc
enum LoginType: NSInteger {
    case signIn
    case signUp
}

class LoginViewController: UITabBarController{
    var usernameTextField: String?
    var password1TextField: String?
    var password2TextField: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViewControllers()
    }
    
    func setUpViewControllers() {
        self.view.backgroundColor = .white
        
        let signInViewController = UIViewController()
        signInViewController.title = "Sign In"
        signInViewController.tabBarItem = UITabBarItem(title: "Sign In", image: nil, tag: 0)
        let signInView =  signInView()
        signInView.delegate = self
        signInViewController.view = signInView
        
        let signUpViewController = UIViewController()
        signUpViewController.title = "Sign Up"
        signUpViewController.tabBarItem = UITabBarItem(title: "Sign Up", image: nil, tag: 1)
        let signUpView =  signUpView()
        signUpView.delegate = self
        signUpViewController.view = signUpView
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.stackedLayoutAppearance = itemAppearance
        tabBarAppearance.backgroundColor = .systemGray6
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
        
        viewControllers = [signInViewController, signUpViewController]
    }
}

// MARK: View Delegate

extension LoginViewController: signInViewDelegate, signUpViewDelegate {
    func signInButtonTapped(_ view: signInView, username: String, password: String) {
        Authentication.shared.signIn(username: username, password: password) { [weak self] result in
            self?.handleLogin(result)
        }
    }
    
    func signUpButtonTapped(_ view: signUpView, username: String, password1: String, password2: String) {
        guard password1 == password2 else {
            RootCoordinator.shared.displayPopup(title: "Password Mismatch", message: "Password1 did not match Password2")
            return
        }
        Authentication.shared.signUp(username: username, password: password2) { [weak self] result in
            self?.handleLogin(result)
        }
    }
}

// MARK: Action

extension LoginViewController {
    
    private func handleLogin(_ result: Result<String?, AuthError>) {
        guard case .success(let token) = result else {
            displayLoginError(for: result)
            return
        }
        
        if let token = token {
            RootCoordinator.shared.moveTo(.contactList(token: token))
        } else {
            RootCoordinator.shared.moveTo(.login)
            RootCoordinator.shared.displayPopup(title: "Signup Success", message: nil)
        }
    }
    
    private func displayLoginError(for result: Result<String?, AuthError>) {
        guard case .failure(let error) = result else {
            RootCoordinator.shared.displayPopup(title: "Authentication Failed", message: "Unknown Error")
            return
        }
        switch error {
        case .invalidPassword:
            RootCoordinator.shared.displayPopup(title: "Login Failed", message: "Invalid Password")
        case .invalidUsername:
            RootCoordinator.shared.displayPopup(title: "Login Failed", message: "Invalid Username")
        case .usernameTaken:
            RootCoordinator.shared.displayPopup(title: "SignUp Failed", message: "Username is already taken")
        case .unknown:
            RootCoordinator.shared.displayPopup(title: "SignUp Failed", message: "Please try again")
        }
    }
}
