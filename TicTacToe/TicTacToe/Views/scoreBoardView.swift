import UIKit

class scoreBoardView: UIView {
    let playerOne = UILabel()
    let playerTwo = UILabel()
    let scoreView1 = UILabel()
    let scoreView2 = UILabel()
    var score1 = 0
    var score2 = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.addSubview(playerOne)
        playerOne.translatesAutoresizingMaskIntoConstraints = false
        playerOne.text = "player_1"
        playerOne.textColor = .tintColor.withAlphaComponent(0.85)
        playerOne.textAlignment = .justified
        playerOne.font = .boldSystemFont(ofSize: 20)
        
        self.addSubview(playerTwo)
        playerTwo.translatesAutoresizingMaskIntoConstraints = false
        playerTwo.text = "player_2"
        playerTwo.textColor = .tintColor.withAlphaComponent(0.85)
        playerTwo.textAlignment = .justified
        playerTwo.font = .boldSystemFont(ofSize: 20)
        
        self.addSubview(scoreView1)
        scoreView1.translatesAutoresizingMaskIntoConstraints = false
        scoreView1.text = "\(score1)"
        scoreView1.textColor = .red
        scoreView1.textAlignment = .justified
        scoreView1.font = .boldSystemFont(ofSize: 45)
        
        self.addSubview(scoreView2)
        scoreView2.translatesAutoresizingMaskIntoConstraints = false
        scoreView2.text = "\(score2)"
        scoreView2.textColor = .black
        scoreView2.textAlignment = .justified
        scoreView2.font = .boldSystemFont(ofSize: 45)
        
        NSLayoutConstraint.activate([
            playerOne.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            playerOne.heightAnchor.constraint(equalToConstant: 40),
            playerOne.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            
            playerTwo.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            playerTwo.heightAnchor.constraint(equalToConstant: 40),
            playerTwo.leadingAnchor.constraint(equalTo: playerOne.trailingAnchor, constant: 0),
            playerTwo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            scoreView1.topAnchor.constraint(equalTo: playerOne.bottomAnchor, constant: 4),
            scoreView1.heightAnchor.constraint(equalToConstant: 48),
            scoreView1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60),
            
            scoreView2.topAnchor.constraint(equalTo: playerTwo.bottomAnchor, constant: 4),
            scoreView2.heightAnchor.constraint(equalToConstant: 48),
            scoreView2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
        ])
    }
    
    public func incrementScoreFor(_ player:Players) {
        if player == Players.player1 {
            score1 += 1
            scoreView1.text = String(score1)
        } else {
            score2 += 1
            scoreView2.text = String(score2)
        }
    }
    
    public func reset() {
        score1 = 0
        score2 = 0
        scoreView1.text = String(score1)
        scoreView2.text = String(score2)
    }
}
