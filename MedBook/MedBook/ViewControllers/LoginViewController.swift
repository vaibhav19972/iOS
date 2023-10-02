import UIKit

class LoginViewController: UIViewController {
    
    // UILabel for the heading
    private let heading: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome,"
        label.font = UIFont(name: "Degular-Bold", size: 32)
        label.textColor = .label
        return label
    }()
    
    // UILabel for the subheading
    private let subHeading: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "log in to continue"
        label.font = UIFont(name: "Degular-Bold", size: 32)
        label.textColor = .systemGray3
        return label
    }()
    
    // UITextField for entering the username/email
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.font = UIFont(name: "Degular-Semibold", size: 18)
        textField.autocapitalizationType = .none
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // UITextField for entering the password
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.font = UIFont(name: "Degular-Semibold", size: 18)
        textField.autocapitalizationType = .none
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // Login button
    private let loginButton: UIButton = {
        let button = Button()
        button.setTitle("Login ->", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the views and activate constraints
        setupView()
        activateConstraits()
    }
    private func setupView() {
        // Insert the background view as the first subview
        view.insertSubview(BackgroundView(frame: self.view.bounds), at: 0)
        
        view.addSubview(heading)
        view.addSubview(subHeading)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        
        // Create and add a line below the usernameTextField
        let usernameLine = CALayer()
        usernameLine.frame = CGRect(x: 0, y: 35,width: view.frame.width-60, height: 1.0)
        usernameLine.backgroundColor = UIColor.systemGray3.cgColor
        usernameTextField.layer.addSublayer(usernameLine)
        
        // Create and add a line below the passwordTextField
        let passwordLine = CALayer()
        passwordLine.frame = CGRect(x: 0, y: 35,width: view.frame.width-60, height: 1.0)
        passwordLine.backgroundColor = UIColor.systemGray3.cgColor
        passwordTextField.layer.addSublayer(passwordLine)
        
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(authAndLogin), for: .touchUpInside)
    }
    
    private func activateConstraits() {
        NSLayoutConstraint.activate([
            heading.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            heading.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            subHeading.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 10),
            subHeading.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            
            usernameTextField.topAnchor.constraint(equalTo: subHeading.bottomAnchor, constant: 80),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 40),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 180),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // Function to handle authentication and login
    @objc private func authAndLogin() {
        let email = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        Authentication.shared.signIn(username: email, password: password) { result in
            guard case .success(let token) = result else {
                RootCoordinator.shared.displayPopup(title: "Login Failed", message: "Invalid credentials")
                return
            }
            if let token = token {
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.set(token, forKey: "userToken")
                RootCoordinator.shared.moveTo(.secret(token: token))
            }
        }
    }
}
