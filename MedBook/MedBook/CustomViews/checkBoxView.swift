import UIKit

class checkBoxView: UIView {
    
     private let checkboxButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "multiply"), for: .selected)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "NA"
        label.font = UIFont(name: "Degular-Semibold", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(checkboxButton)
        addSubview(label)
        
        // Checkbox constraints
        NSLayoutConstraint.activate([
            checkboxButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkboxButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkboxButton.widthAnchor.constraint(equalToConstant: 24),
            checkboxButton.heightAnchor.constraint(equalToConstant: 24),
            
            label.leadingAnchor.constraint(equalTo: checkboxButton.trailingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // Function to select/unselect the checkbox
    public func selectCheckbox(_ isSelected: Bool) {
        checkboxButton.isSelected = isSelected
    }
}
