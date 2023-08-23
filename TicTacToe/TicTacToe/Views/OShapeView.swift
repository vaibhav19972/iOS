import UIKit

class OShapeView: UIView {
    private let shapeLayer = CAShapeLayer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        // Configure the shape layer
        shapeLayer.lineWidth = 12.0
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(shapeLayer)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        // Update the shape layer's path when the view's bounds change
        let path = UIBezierPath(roundedRect: CGRect(x: 20, y: 20, width: 65, height: 65), cornerRadius: 32)
        shapeLayer.path = path.cgPath
    }
    
    public func startAnimation() {
        // Create a CABasicAnimation to animate the strokeEnd property
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.0
        shapeLayer.add(animation, forKey: "strokeAnimation")
    }
}

