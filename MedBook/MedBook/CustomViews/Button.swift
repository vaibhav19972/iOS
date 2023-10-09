import UIKit

class Button: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        layer.cornerRadius = 12
        titleLabel?.font = UIFont(name: "Degular-semibold", size: 22)
        backgroundColor = UIColor(rgb: 0xFFFFFF)
        setTitleColor(.black, for: .normal)
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 1
    }
}
