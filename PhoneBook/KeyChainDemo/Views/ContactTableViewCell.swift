import UIKit

class ContactTableViewCell: UITableViewCell {
    
    let headerImage = UIImageView()
    let firstname = UILabel()
    let lastname = UILabel()
    let mobile = UILabel()
    let moreOptionsButton = UIButton()
    
    static let identifier = "ContactViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(headerImage)
        headerImage.translatesAutoresizingMaskIntoConstraints = false
        headerImage.contentMode = .scaleAspectFit
        headerImage.clipsToBounds = true
        headerImage.layer.cornerRadius = 32
        headerImage.layer.borderWidth = 1
        headerImage.layer.borderColor = UIColor.systemGray3.cgColor
        headerImage.backgroundColor = .systemGray6
        headerImage.image = UIImage(named: "contactDefaultImage")
        
        addSubview(firstname)
        firstname.translatesAutoresizingMaskIntoConstraints = false
        firstname.text = "Name  : empty"
        firstname.textColor = .black
        firstname.font = .systemFont(ofSize: 15, weight: .semibold)
        firstname.contentMode = .scaleAspectFit
        
        addSubview(lastname)
        lastname.translatesAutoresizingMaskIntoConstraints = false
        lastname.text = "Family : empty"
        lastname.textColor = .black
        lastname.font = .systemFont(ofSize: 15, weight: .semibold)
        lastname.contentMode = .scaleAspectFit
        
        addSubview(mobile)
        mobile.translatesAutoresizingMaskIntoConstraints = false
        mobile.text = "Mobile : empty"
        mobile.textColor = .black
        mobile.font = .systemFont(ofSize: 15, weight: .semibold)
        mobile.contentMode = .scaleAspectFit
        
        addSubview(moreOptionsButton)
        moreOptionsButton.translatesAutoresizingMaskIntoConstraints = false
        moreOptionsButton.contentMode = .scaleAspectFit
        moreOptionsButton.setBackgroundImage(UIImage(systemName: "phone.arrow.up.right"), for: .normal)
        moreOptionsButton.tintColor = .label
        
        NSLayoutConstraint.activate([
            headerImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 13),
            headerImage.heightAnchor.constraint(equalToConstant: 64),
            headerImage.widthAnchor.constraint (equalToConstant: 64),
            
            firstname.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            firstname.leadingAnchor.constraint(equalTo: headerImage.trailingAnchor, constant: 20),
            firstname.heightAnchor.constraint(equalToConstant: 16),
            firstname.widthAnchor.constraint (equalToConstant: 240),
            
            lastname.topAnchor.constraint(equalTo: firstname.bottomAnchor, constant: 2),
            lastname.leadingAnchor.constraint(equalTo: headerImage.trailingAnchor, constant: 20),
            lastname.heightAnchor.constraint(equalToConstant: 16),
            lastname.widthAnchor.constraint (equalToConstant: 240),
            
            mobile.topAnchor.constraint(equalTo: lastname.bottomAnchor, constant: 2),
            mobile.leadingAnchor.constraint(equalTo: headerImage.trailingAnchor, constant: 20),
            mobile.heightAnchor.constraint(equalToConstant: 16),
            mobile.widthAnchor.constraint (equalToConstant: 240),
            
            moreOptionsButton.centerYAnchor.constraint(equalTo:centerYAnchor ),
            moreOptionsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            moreOptionsButton.heightAnchor.constraint(equalToConstant: 24),
            moreOptionsButton.widthAnchor.constraint (equalToConstant: 24),
        ])
    }
    public func configure(firstname: String?, lastname: String?, mobile: String?) {
        if (firstname?.isEmpty != nil) {
            self.firstname.text = "Name  : \(firstname!)"
        }
        if (lastname?.isEmpty != nil) {
            self.lastname.text = "Family : \(lastname!)"
        }
        if (mobile?.isEmpty != nil) {
            self.mobile.text = "Mobile: \(mobile!)"
        }
    }
}

