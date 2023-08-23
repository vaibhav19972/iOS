import UIKit

protocol signUpViewDelegate: NSObject {
    func signUpButtonTapped(_ view: signUpView, username: String, password1: String, password2: String)
}

class signUpView: UIView {
    weak var delegate: signUpViewDelegate?
    
    init() {
        super.init(frame: .zero)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
    
    private var phoneBookIcon: UIImageView = {
        let iconImageView = UIImageView()
        iconImageView.image = UIImage(named: "phoneBookIcon")
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 32
        iconImageView.layer.borderWidth = 3
        iconImageView.layer.borderColor = UIColor.systemGray2.cgColor
        iconImageView.backgroundColor = .systemGray6
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        return iconImageView
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = 20
        textField.textAlignment = .center
        textField.backgroundColor = .systemGray6
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField1: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = 20
        textField.textAlignment = .center
        textField.backgroundColor = .systemGray6
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField2: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = 20
        textField.textAlignment = .center
        textField.backgroundColor = .systemGray6
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func setUpViews() {
        self.backgroundColor = .tintColor
        addSubview(phoneBookIcon)
        addSubview(usernameTextField)
        addSubview(passwordTextField1)
        addSubview(passwordTextField2)
        
        actionButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            phoneBookIcon.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            phoneBookIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 150),
            phoneBookIcon.widthAnchor.constraint(equalToConstant: 80),
            phoneBookIcon.heightAnchor.constraint(equalToConstant: 80),
            
            usernameTextField.topAnchor.constraint(equalTo: phoneBookIcon.bottomAnchor, constant: 80),
            usernameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
            usernameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField1.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
            passwordTextField1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
            passwordTextField1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100),
            passwordTextField1.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField2.topAnchor.constraint(equalTo: passwordTextField1.bottomAnchor, constant: 16),
            passwordTextField2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
            passwordTextField2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100),
            passwordTextField2.heightAnchor.constraint(equalToConstant: 40.0),
            
            
            actionButton.topAnchor.constraint(equalTo: passwordTextField2.bottomAnchor, constant: 46),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100),
            actionButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    @objc private func signUpTapped() {
        let username = usernameTextField.text ?? ""
        let password1 = passwordTextField1.text ?? ""
        let password2 = passwordTextField2.text ?? ""
        
        delegate?.signUpButtonTapped(self, username: username, password1: password1, password2: password2)
        
    }
    
}
