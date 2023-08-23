import UIKit

class contactTableViewController: UIViewController {
    
    var tableView: UITableView!
    var token: String!
    
    let viewModel = ContactViewModel()
    
    private var contact: [Contact] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(token: String) {
        self.token = token
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.addObserver(self)
        viewModel.reloadData(token)
    }
    private func setupView() {
        self.navigationController?.navigationBar.barTintColor = UIColor.systemGray5
        self.navigationItem.title = "Contacts"
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.badge.plus"), style: .plain, target: self, action: #selector(addContact))
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButton))
        navigationItem.rightBarButtonItems = [rightBarButtonItem]
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        rightBarButtonItem.tintColor = UIColor.tintColor
        leftBarButtonItem.tintColor = UIColor.tintColor
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemGray4
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func showAddPersonDialog() {
        let alert =  UIAlertController(title: "Add Person", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "First Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Last Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Mobile"
        }
        
        let saveAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            self?.viewModel.addContact(firstname: alert.textFields?[0].text, lastname: alert.textFields?[1].text, mobile: alert.textFields?[2].text, token: self?.token ?? "")
        }
        alert.addAction(saveAction)
        present(alert, animated: true)
    }
    
    private func showEditPersonDialog(for indexPath: IndexPath) {
        let alert =  UIAlertController(title: "Edit Person", message: nil, preferredStyle: .alert)
        let contact = contact[indexPath.row]
        alert.addTextField { (textField) in
            textField.placeholder = "First Name"
            textField.text = contact.firstname
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Last Name"
            textField.text = contact.lastname
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Mobile"
            textField.text = contact.mobile
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            self?.viewModel.updateContact(at: indexPath.row, firstname: alert.textFields?[0].text, lastname: alert.textFields?[1].text, mobile: alert.textFields?[2].text, token: self?.token ?? "")
        }
        alert.addAction(saveAction)
        present(alert, animated: true)
    }
    
    //Action handler
    @objc func backButton(_ sender: Any) {
        RootCoordinator.shared.moveTo(.login)
    }
    @objc func addContact(_ sender: Any) {
        showAddPersonDialog()
    }
}
// MARK: - UITableViewDelegate

extension contactTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showEditPersonDialog(for: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { [weak self] (_, _, _) in
            self?.viewModel.deleteContact(at: indexPath.row, token: self?.token ?? "")
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - UITableViewDataSource

extension contactTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath) as! ContactTableViewCell
        let contact = contact[indexPath.row]
        cell.configure(firstname: contact.firstname, lastname: contact.lastname, mobile: contact.mobile)
        cell.backgroundColor = .systemGray5
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
// MARK: - PeopleViewModelObserver

extension contactTableViewController: ContactViewModelObserver {
    func viewModelDidUpdate(user contacts: [Contact]) {
        self.contact = contacts
    }
}
