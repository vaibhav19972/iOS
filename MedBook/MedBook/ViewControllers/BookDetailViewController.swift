import UIKit

class BookDetailViewController: UIViewController {

    let bookImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // Heading label for the book name
    let heading: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "N/A"
        label.font = UIFont(name: "Degular-Bold", size: 32)
        label.textColor = .label
        return label
    }()
    
    // Subheading label for additional information
    let subHeading: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "N/A"
        label.numberOfLines = 0
        label.font = UIFont(name: "Degular-Semibold", size: 28)
        label.textColor = .label
        return label
    }()
    
    let publishDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "N/A"
        label.numberOfLines = 0
        label.font = UIFont(name: "Degular-Semibold", size: 18)
        label.textColor = .label
        return label
    }()
    
    let content: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "N/A"
        label.numberOfLines = 0
        label.font = UIFont(name: "Degular-Semibold", size: 18)
        label.textColor = .label
        return label
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
        view.addSubview(bookImage)
        view.addSubview(heading)
        view.addSubview(subHeading)
        view.addSubview(publishDate)
        view.addSubview(content)
    }
    
    private func activateConstraits() {
        NSLayoutConstraint.activate([
            bookImage.topAnchor.constraint(equalTo: view.topAnchor),
            bookImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bookImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bookImage.heightAnchor.constraint(equalToConstant: 240),
            
            heading.topAnchor.constraint(equalTo: bookImage.bottomAnchor, constant: 20),
            heading.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            heading.trailingAnchor.constraint(equalTo: publishDate.leadingAnchor, constant: -10),
            
            subHeading.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 10),
            subHeading.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            subHeading.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            publishDate.topAnchor.constraint(equalTo: bookImage.bottomAnchor, constant: 20),
            publishDate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:  -10),
            
            content.topAnchor.constraint(equalTo: subHeading.bottomAnchor),
            content.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}
