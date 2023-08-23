import Foundation
import CoreData

@objc(Contact)
public class Contact: NSManagedObject {
    convenience init(firstname: String?, lastname: String?, mobile: String?, token: String) {
        self.init(entity: Self.entity(), insertInto: nil)
        self.firstname = firstname?.isEmpty == false ? firstname : nil
        self.lastname = lastname?.isEmpty == false ? lastname : nil
        self.mobile = mobile?.isEmpty == false ? mobile : nil
        self.token = token
    }

    func update(firstname: String?, lastname: String?, mobile: String?, token: String) {
        self.firstname = firstname?.isEmpty == false ? firstname : nil
        self.lastname = lastname?.isEmpty == false ? lastname : nil
        self.mobile = mobile?.isEmpty == false ? mobile : nil
        self.token = token
    }
}
