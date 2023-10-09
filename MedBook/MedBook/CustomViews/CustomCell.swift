import UIKit

class CustomCell: UITableViewCell {
    static let reuseIdentifier = "CustomCell"
    
    let bookImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let cellLabel: UILabel = {
        let label = UILabel()
        label.text = "NA"
        label.font = UIFont(name: "Degular-Semibold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(bookImage)
        addSubview(cellLabel)
        
        // Checkbox constraints
        NSLayoutConstraint.activate([
            bookImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            bookImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            bookImage.widthAnchor.constraint(equalToConstant: 40),
            bookImage.heightAnchor.constraint(equalToConstant: 40),
            
            cellLabel.leadingAnchor.constraint(equalTo: bookImage.trailingAnchor, constant: 8),
            cellLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
