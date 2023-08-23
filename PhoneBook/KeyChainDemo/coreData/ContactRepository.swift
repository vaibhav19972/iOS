import UIKit

class ContactRepository {
    private let dataManager = ContactDataManager.shared
        
    func fetch(_ token: String) -> [Contact] {
            return dataManager.fetch(token)
        }
        
        func addContact(_ contact: Contact) {
            dataManager.insert(contact)
        }
        
        func deleteUser(_ contact: Contact) {
            dataManager.delete(contact)
        }
        
        func save() {
            dataManager.save()
        }
    }
