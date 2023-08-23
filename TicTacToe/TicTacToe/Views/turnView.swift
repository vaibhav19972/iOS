import UIKit

class turnView: UIView {
    let turnLabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.addSubview(turnLabel)
        turnLabel.translatesAutoresizingMaskIntoConstraints = false
        turnLabel.text = "player 1 turn's"
        turnLabel.textColor = .tintColor.withAlphaComponent(0.85)
        turnLabel.backgroundColor = .red.withAlphaComponent(0.3)
        turnLabel.layer.borderColor = UIColor.systemGray3.withAlphaComponent(0.8).cgColor
        turnLabel.layer.borderWidth = 2
        turnLabel.textAlignment = .center
        turnLabel.font = .boldSystemFont(ofSize: 24)
        
        
        
        NSLayoutConstraint.activate([
            turnLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            turnLabel.heightAnchor.constraint(equalToConstant: 40),
            turnLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 85),
            turnLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -85),
        ])
    }
    
    public func update(player: Players) {
        if player == Players.player1 {
            turnLabel.text = "player 1 turn's"
            turnLabel.backgroundColor = .red.withAlphaComponent(0.3)
        } else {
            turnLabel.text = "player 2 turn's"
            turnLabel.backgroundColor = .systemGray4
        }
        
    }
}
