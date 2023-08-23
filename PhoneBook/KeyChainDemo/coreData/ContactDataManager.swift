import CoreData

class ContactDataManager {
        static let shared = ContactDataManager()

        private lazy var persistenceContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "ContactData")
            container.loadPersistentStores { (storeDescription, error) in
                if let error = error as? NSError {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            }
            return container
        }()

        private lazy var context = persistenceContainer.viewContext

        private init() {}

        // MARK: Public methods

    func fetch(_ token: String) -> [Contact] {
            do {
                let request = Contact.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "firstname", ascending: true)]
                request.predicate = NSPredicate(format: "token LIKE '\(token)'")
                return try context.fetch(request)
            } catch {
                let nserror = error as NSError
                fatalError("Fetch error occurred \(nserror), \(nserror.userInfo)")
            }
        }

        func insert(_ contact: Contact) {
            context.insert(contact)
            save()
        }

        func delete(_ contact: Contact) {
            context.delete(contact)
            save()
        }

        func save() {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Save error occurred \(nserror), \(nserror.userInfo)")
            }
        }

        func printDefaultDirectoryPath() {
            debugPrint(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
        }
    }

