import UIKit

enum MarkType {
    case empty
    case circle
    case cross
}

class boardCollectionViewCell: UICollectionViewCell {
    
    var shapeContentView = UIView()
    let xShape = XShapeView()
    let oShape = OShapeView()
    
    static let identifier = "PostHeaderViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        shapeContentView.addSubview(xShape)
        xShape.isHidden = true
        xShape.translatesAutoresizingMaskIntoConstraints = false
        
        shapeContentView.addSubview(oShape)
        oShape.isHidden = true
        oShape.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(shapeContentView)
        shapeContentView.translatesAutoresizingMaskIntoConstraints = false
        shapeContentView.layer.cornerRadius = 16
        
        NSLayoutConstraint.activate([
            shapeContentView.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 8),
            shapeContentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            shapeContentView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            shapeContentView.bottomAnchor.constraint (equalTo: bottomAnchor, constant: -8),
            
            xShape.leadingAnchor.constraint(equalTo:shapeContentView.leadingAnchor),
            xShape.trailingAnchor.constraint(equalTo: shapeContentView.trailingAnchor),
            xShape.topAnchor.constraint(equalTo: shapeContentView.topAnchor),
            xShape.bottomAnchor.constraint (equalTo: shapeContentView.bottomAnchor),
            
            oShape.leadingAnchor.constraint(equalTo:shapeContentView.leadingAnchor),
            oShape.trailingAnchor.constraint(equalTo: shapeContentView.trailingAnchor),
            oShape.topAnchor.constraint(equalTo: shapeContentView.topAnchor),
            oShape.bottomAnchor.constraint (equalTo: shapeContentView.bottomAnchor),
        ])
    }
    
    public func isSelected() -> Bool {
        if (oShape.isHidden && xShape.isHidden) {
            return false
        } else {
            return true
        }
    }
    
    public func updateShape(_ type: MarkType) {
        if (type == .cross) {
            oShape.isHidden = true
            xShape.isHidden = false
            xShape.startAnimation()
            cellSelected()
        } else if (type == .circle) {
            xShape.isHidden = true
            oShape.isHidden = false
            oShape.startAnimation()
            cellSelected()
        } else {
            oShape.isHidden = true
            xShape.isHidden = true
            shapeContentView.layer.borderColor = UIColor.clear.cgColor
            shapeContentView.layer.borderWidth = 0
            shapeContentView.backgroundColor = .clear
        }
    }
    private func cellSelected() {
        shapeContentView.layer.borderColor = UIColor.systemGray.cgColor
        shapeContentView.layer.borderWidth = 4
        shapeContentView.backgroundColor = .systemGray5
    }
}
