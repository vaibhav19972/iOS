import UIKit

class XShapeView: UIView {
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
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(shapeLayer)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        // Update the shape layer's path when the view's bounds change
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 25, y: 25))
        path.addLine(to: CGPoint(x: bounds.width - 25, y: bounds.height - 25))
        path.move(to: CGPoint(x: bounds.width - 25, y: 25))
        path.addLine(to: CGPoint(x: 25, y: bounds.height - 25))
        shapeLayer.path = path.cgPath
    }
    
    public func startAnimation() {
        // Create a CABasicAnimation to animate the strokeEnd property
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.0
        shapeLayer.add(animation, forKey: "strokeEnd")
    }
}

