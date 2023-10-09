import UIKit

class SignUpViewController: UIViewController {
    
    // UILabel for the heading
    private let heading: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome"
        label.font = UIFont(name: "Degular-Bold", size: 32)
        label.textColor = .label
        return label
    }()

    // UILabel for the subheading
    private let subHeading: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "sign up to continue"
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
        textField.font = UIFont(name: "Degular-Semibold", size: 18)
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // checkBoxView for checking minimum 8 password character requirements
    private let minimumChar: checkBoxView = {
        let view = checkBoxView()
        view.label.text = "At least 8 characters"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // checkBoxView for checking if the password contains atleast one uppercase letter
    private let upperChar: checkBoxView = {
        let view = checkBoxView()
        view.label.text = "Must contain an uppercase letter"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // checkBoxView for checking if the password contains a special character
    private let specialChar: checkBoxView = {
        let view = checkBoxView()
        view.label.text = "Must contain a special character"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // UIPickerView for selecting a country
    let pickerView = UIPickerView()
    var CountryNames = [String]()
    
    // UIButton for submitting the sign-up form
    let submitButton: UIButton = {
        let button = Button()
        button.setTitle("Let's Go ->", for: .normal)
        button.titleLabel?.font = UIFont(name: "Degular-Bold", size: 22)
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
        passwordTextField.delegate = self
        
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
        
        view.addSubview(minimumChar)
        view.addSubview(upperChar)
        view.addSubview(specialChar)
        
        view.addSubview(pickerView)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        loadCountries()
        
        view.addSubview(submitButton)
        submitButton.addTarget(self, action: #selector(validateAndSignUp), for: .touchUpInside)
    }
    
    // Function to load country names for the UIPickerView
    private func loadCountries() {
        CountryDataAPI.shared.fetchCountryData { response in
            for (_, countryData) in response.data {
                self.CountryNames.append(countryData.country)
            }
            DispatchQueue.main.async {
                self.pickerView.reloadAllComponents()
            }
        }
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
            
            minimumChar.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            minimumChar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            minimumChar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            minimumChar.heightAnchor.constraint(equalToConstant: 30),
            
            upperChar.topAnchor.constraint(equalTo: minimumChar.bottomAnchor, constant: 10),
            upperChar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            upperChar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            upperChar.heightAnchor.constraint(equalToConstant: 30),
            
            specialChar.topAnchor.constraint(equalTo: upperChar.bottomAnchor, constant: 10),
            specialChar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            specialChar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            specialChar.heightAnchor.constraint(equalToConstant: 30),
            
            pickerView.topAnchor.constraint(equalTo: specialChar.bottomAnchor, constant: 20),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -40),
            pickerView.heightAnchor.constraint(equalToConstant: 140),
            
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            submitButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    @objc private func validateAndSignUp() {
        let email = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let isValidemail = isValidEmail(email)
        let isValidPassword = isValidPassword(password)
        
        if isValidemail && isValidPassword {
            Authentication.shared.signUp(username: email, password: password) {_ in
                RootCoordinator.shared.moveTo(.login)
                RootCoordinator.shared.displayPopup(title: "Signup Success", message: "Please login to continue")
            }
        } else {
            RootCoordinator.shared.displayPopup(title: "Invalid credential", message: "Please enter a valid Email and password")
        }
    }
    
    // MARK: TextField Validation Helpers
    
    // Function to validate an email address using a regular expression
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    // Function to validate a password using a regular expression
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = #"(?=.*[A-Z])(?=.*[^A-Za-z0-9]).{8,}"#
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // Function to check if the password contains an uppercase letter
    func checkUpperChar(_ password: String) -> Bool {
        let passwordRegex = ".*[A-Z]+.*"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // Function to check if the password meets the minimum character requirement
    func checkMinimumChar(_ password: String) -> Bool {
        let passwordRegex = "^.{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    // Function to check if the password meets the minimum character requirement
    func checkSpecialChar(_ password: String) -> Bool {
        let passwordRegex = ".*[!@#$%^&*()_+\\-=\\[\\]{};':\"<>,./?].*"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}

// MARK: PickerView Handler

// UIPickerView delegate and data source methods
extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CountryNames.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CountryNames[row]
    }
}

// UITextField delegate method to handle text changes
extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        
        // Calculate the updated text
        let key = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // Make visible that password requirments are met
        checkMinimumChar(key) ? minimumChar.selectCheckbox(true) : minimumChar.selectCheckbox(false)
        checkUpperChar(key) ? upperChar.selectCheckbox(true) : upperChar.selectCheckbox(false)
        checkSpecialChar(key) ? specialChar.selectCheckbox(true) : specialChar.selectCheckbox(false)
        return true
    }
}
