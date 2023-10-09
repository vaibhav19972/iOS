import UIKit

class SecretViewController: UIViewController {
    
    var token: String!
    var searchResults: [Document]?
    
    // ImageView to display a book icon
    private let bookImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "book.fill")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // Heading label for the app name
    private let heading: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "MedBook"
        label.font = UIFont(name: "Degular-Bold", size: 32)
        label.textColor = .label
        return label
    }()

    // Subheading label for additional information
    private let subHeading: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Which topic Interests you today?"
        label.numberOfLines = 0
        label.font = UIFont(name: "Degular-Semibold", size: 28)
        label.textColor = .label
        return label
    }()
    
    private let searchBar: UISearchBar = {
       let searchbar = UISearchBar()
        searchbar.placeholder = "Search for books"
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        return searchbar
    }()
    
    private let tableView = UITableView()
        
    
    // Logout button
    private let logoutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.font = UIFont(name: "Degular-Semibold", size: 18)
        button.setTitleColor(.systemRed, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Initializer to receive a token
    init(token: String) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the views and activate constraints
        setupView()
        activateConstraits()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(rgb: 0xFAFAFA)
        
        view.addSubview(bookImage)
        view.addSubview(heading)
        view.addSubview(subHeading)
        view.addSubview(searchBar)
        searchBar.delegate = self
        
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        view.addSubview(logoutButton)
        
        // Add an action to the logout button
        logoutButton.addTarget(self, action: #selector(logoutButtonClicked), for: .touchUpInside)
    }
    
    private func activateConstraits() {
        NSLayoutConstraint.activate([
            bookImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            bookImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bookImage.heightAnchor.constraint(equalToConstant: 36),
            bookImage.widthAnchor.constraint(equalToConstant: 36),

            heading.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 10),
            heading.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heading.topAnchor.constraint(equalTo: bookImage.topAnchor, constant: -4),
            
            subHeading.topAnchor.constraint(equalTo: heading.topAnchor, constant: 120),
            subHeading.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subHeading.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            
            searchBar.topAnchor.constraint(equalTo: subHeading.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -10),
            
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 180),
            logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // Function to handle the logout button click
    @objc private func logoutButtonClicked() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        RootCoordinator.shared.moveTo(.landing)
    }
}

extension SecretViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text else {
            return
        }
        DispatchQueue.global().async {
            BookListingAPI.shared.fetchSearchResults(searchText: searchText, limit: 15) { [weak self] results in
                self?.searchResults = results.docs
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension SecretViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.reuseIdentifier, for: indexPath) as! CustomCell
        if let searchResults = searchResults {
            let book = searchResults[indexPath.row]
            cell.cellLabel.text = book.title
            if let coverKey = book.cover_i {
                DispatchQueue.global().async {
                    BookListingAPI.shared.loadCoverImage(key: coverKey) { result in
                        DispatchQueue.main.async {
                            cell.bookImage.image = UIImage(data: result)
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookDetailVC = BookDetailViewController()
        if let book = searchResults?[indexPath.row] {
            DispatchQueue.global().async {
                BookListingAPI.shared.listBook(key: book.key) { result in
                    DispatchQueue.main.async {
                        bookDetailVC.heading.text = result.title
                        bookDetailVC.subHeading.text = book.author_name?.first
                        bookDetailVC.publishDate.text = result.first_publish_date
                        bookDetailVC.content.text = result.description
                    }
                }
            }
            if let coverKey = book.cover_i {
                DispatchQueue.global().async {
                    BookListingAPI.shared.loadCoverImage(key: coverKey) { result in
                        DispatchQueue.main.async {
                            bookDetailVC.bookImage.image = UIImage(data: result)
                        }
                    }
                }
            }
        }
        navigationController?.present(bookDetailVC, animated: true)
        
    }
}
