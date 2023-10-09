import UIKit

class LandingViewController: UIViewController {
    
    // Heading label for the app name
    private let heading: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MedBook"
        label.font = UIFont(name: "Degular-Bold", size: 32)
        label.textColor = .label
        return label
    }()
    
    // Sign up button
    let signUpButton: UIButton = {
        let button = Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Signup", for: .normal)
        return button
    }()
    
    // Login button
    let loginButton: UIButton = {
        let button = Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        return button
    }()
    
    // Landing image view
    let landingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "landing")
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        view.addSubview(landingImage)
        view.addSubview(heading)
        
        // Add the sign-up button and set its action
        view.addSubview(signUpButton)
        signUpButton.addTarget(self, action: #selector(SignUpClicked), for: .touchUpInside)
        
        // Add the login button and set its action
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(LogInClicked), for: .touchUpInside)
    }
    
    private func activateConstraits() {
        NSLayoutConstraint.activate([
            heading.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            heading.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            landingImage.topAnchor.constraint(equalTo: heading.bottomAnchor),
            landingImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            landingImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            signUpButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // Function to handle sign-up button click
    @objc private func SignUpClicked() {
        let signUpVC = SignUpViewController()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    // Function to handle login button click
    @objc private func LogInClicked() {
        let logInVC = LoginViewController()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(logInVC, animated: true)
    }
}
