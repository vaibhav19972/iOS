protocol ContactViewModelObserver: AnyObject {
    func viewModelDidUpdate(user: [Contact])
}

class ContactViewModel {
    private let repository = ContactRepository()
    
    private weak var observer: ContactViewModelObserver? = nil {
        didSet {
            observer?.viewModelDidUpdate(user: Contact)
        }
    }

    public var Contact: [Contact] = [] {
        didSet {
            observer?.viewModelDidUpdate(user: Contact)
        }
    }
    
    func reloadData(_ token: String) {
        self.Contact = repository.fetch(token)
    }
    
    func addObserver(_ observer: ContactViewModelObserver) {
        self.observer = observer
    }
    
    func addContact(firstname: String?, lastname: String?, mobile: String?, token: String) {
        let contact = PhoneBook.Contact(firstname: firstname, lastname: lastname, mobile: mobile, token: token)
        repository.addContact(contact)
        reloadData(token)
    }
    
    func updateContact(at index: Int, firstname: String?, lastname: String?, mobile: String?, token: String) {
        let user = Contact[index]
        user.update(firstname: firstname, lastname: lastname, mobile: mobile, token: token)
        repository.save()
        reloadData(token)
    }
    
    func deleteContact(at index: Int, token: String) {
        let user = Contact[index]
        repository.deleteUser(user)
        reloadData(token)
    }
}
