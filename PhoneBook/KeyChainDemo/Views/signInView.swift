import UIKit

protocol signInViewDelegate: NSObject {
    func signInButtonTapped(_ view: signInView, username: String, password: String)
}

class signInView: UIView {
    weak var delegate: signInViewDelegate?
    
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
    
    private let passwordTextField: UITextField = {
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
    
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .systemTeal
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func setUpViews() {
        self.backgroundColor = .tintColor
        addSubview(phoneBookIcon)
        addSubview(usernameTextField)
        addSubview(passwordTextField)
        
        actionButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
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
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            actionButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 102),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100),
            actionButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    @objc private func signInTapped() {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        delegate?.signInButtonTapped(self, username: username, password: password)
    }
    
}
