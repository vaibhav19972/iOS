import UIKit

enum Players {
    case player1
    case player2
}

enum Mode {
    case cpu
    case vs
}

class ViewController: UIViewController {
    
    let logo = UILabel()
    
    @IBOutlet weak var TicTacToeBoardView: UICollectionView!
    let xShape = XShapeView()
    let oShape = OShapeView()
    let winningLine = CAShapeLayer()
    let newGameButton = UIButton()
    
    var timer: Timer?
    let turnBoard = turnView()
    let scoreBoard = scoreBoardView()
    let modeSelectionView = modeView()
    
    var mode = Mode.vs
    var boardState: [Int] = Array(repeating: 0, count: 9)
    var uncheckedRange:[Int] = []
    var turn = Players.player1
    var moves:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        TicTacToeBoardView.register(boardCollectionViewCell.self, forCellWithReuseIdentifier: boardCollectionViewCell.identifier)
        TicTacToeBoardView.collectionViewLayout = UICollectionViewCompositionalLayout(section: createHeaderLayout())
        
        setupView()
        addGridShapeLayer()
    }
    
    private func setupView() {
        view.backgroundColor = .white.withAlphaComponent(0.9)
        
        // setup logo view
        view.addSubview(logo)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.text = "Tic . Tac . Toe"
        logo.textAlignment = .center
        logo.textColor = .systemBrown
        logo.font = .systemFont(ofSize: 25, weight: .semibold)
        logo.contentMode = .scaleAspectFit
        
        // setup button
        view.addSubview(newGameButton)
        newGameButton.translatesAutoresizingMaskIntoConstraints = false
        newGameButton.setImage(UIImage(systemName: "repeat"), for: .normal)
        newGameButton.addTarget(self, action: #selector(newGameTapped), for: .touchUpInside)
        newGameButton.contentVerticalAlignment = .fill
        newGameButton.contentHorizontalAlignment = .fill
        
        // setup game board view
        TicTacToeBoardView.backgroundColor = .red.withAlphaComponent(0.3)
        TicTacToeBoardView.layer.borderColor = UIColor.systemGray3.withAlphaComponent(0.8).cgColor
        TicTacToeBoardView.layer.borderWidth = 5
        TicTacToeBoardView.layer.cornerRadius = 16
        TicTacToeBoardView.delegate = self
        TicTacToeBoardView.dataSource = self
        TicTacToeBoardView.translatesAutoresizingMaskIntoConstraints = false
        TicTacToeBoardView.isScrollEnabled = false
        
        // setup turnView
        view.addSubview(turnBoard)
        turnBoard.translatesAutoresizingMaskIntoConstraints = false
        turnBoard.update(player: turn)
        
        // setup score board
        view.addSubview(scoreBoard)
        scoreBoard.translatesAutoresizingMaskIntoConstraints = false
        scoreBoard.backgroundColor = .systemBrown.withAlphaComponent(0.5)
        
        // setup mode selection view
        view.addSubview(modeSelectionView)
        modeSelectionView.delegate = self
        modeSelectionView.translatesAutoresizingMaskIntoConstraints = false
        modeSelectionView.backgroundColor = .white.withAlphaComponent(0.4)
        
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            logo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            logo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            logo.heightAnchor.constraint (equalToConstant: 50),
            
            newGameButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            newGameButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            newGameButton.heightAnchor.constraint (equalToConstant: 50),
            newGameButton.widthAnchor.constraint(equalToConstant: 50),
            
            TicTacToeBoardView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            TicTacToeBoardView.widthAnchor.constraint(equalTo: view.widthAnchor),
            TicTacToeBoardView.heightAnchor.constraint(equalTo: view.widthAnchor, constant: 10),
            
            turnBoard.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -180),
            turnBoard.widthAnchor.constraint(equalTo: view.widthAnchor),
            turnBoard.heightAnchor.constraint(equalToConstant: 40),
            
            modeSelectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110),
            modeSelectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            modeSelectionView.heightAnchor.constraint(equalToConstant: 60),
            
            scoreBoard.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            scoreBoard.widthAnchor.constraint(equalTo: view.widthAnchor),
            scoreBoard.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    private func createHeaderLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(125), heightDimension: .absolute(125))
        let headerItem = NSCollectionLayoutItem(layoutSize: itemSize)
        headerItem.contentInsets.trailing = 5
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(140), heightDimension: .absolute(130))
        let hearderGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: headerItem, count: 3)
        
        let headerSection = NSCollectionLayoutSection(group: hearderGroup)
        headerSection.contentInsets.leading = 10
        headerSection.contentInsets.top = 8
        return headerSection
    }
    
    private func addGridShapeLayer() {
        let path1 = createHorizontalLine()
        let path2 = createVerticalLine()
        
        let shapeLayer = CAShapeLayer()
        let combinedPath = UIBezierPath()
        combinedPath.append(path1)
        combinedPath.append(path2)
        shapeLayer.path = combinedPath.cgPath
        
        shapeLayer.strokeColor = UIColor.brown.cgColor
        shapeLayer.lineWidth = 5.0
        TicTacToeBoardView.layer.addSublayer(shapeLayer)
    }
    
    
    private func createHorizontalLine() -> UIBezierPath {
        let path1 = UIBezierPath()
        let path2 = UIBezierPath()
        
        path1.move(to: CGPoint(x: 12, y: TicTacToeBoardView.bounds.midY - 63))
        path1.addLine(to: CGPoint(x: TicTacToeBoardView.bounds.width - 12, y: TicTacToeBoardView.bounds.midY - 63))
        
        path2.move(to: CGPoint(x: 12, y: TicTacToeBoardView.bounds.midY + 66))
        path2.addLine(to: CGPoint(x: TicTacToeBoardView.bounds.width - 12, y: TicTacToeBoardView.bounds.midY + 66))
        
        let combinedPath = UIBezierPath()
        combinedPath.append(path1)
        combinedPath.append(path2)
        return combinedPath
    }
    
    private func createVerticalLine() -> UIBezierPath {
        let path1 = UIBezierPath()
        let path2 = UIBezierPath()
        
        path1.move(to: CGPoint(x: 133, y: TicTacToeBoardView.bounds.minY + 10))
        path1.addLine(to: CGPoint(x: 133, y: TicTacToeBoardView.bounds.height - 8))
        
        path1.move(to: CGPoint(x: 258, y: TicTacToeBoardView.bounds.minY + 8))
        path1.addLine(to: CGPoint(x: 258, y: TicTacToeBoardView.bounds.height - 8))
        
        let combinedPath = UIBezierPath()
        combinedPath.append(path1)
        combinedPath.append(path2)
        
        return combinedPath
    }
    
    private func drawWinningLine(pattern: Set<Int>) {
        let path = UIBezierPath()
        
        let startPoint = pattern.min()
        let endPoint = pattern.max()
        
        if (startPoint == 0 ) {
            path.move(to: CGPoint(x: 65, y: 70))
        }
        if (startPoint == 1 ) {
            path.move(to: CGPoint(x: TicTacToeBoardView.bounds.midX, y: 70))
        }
        if (startPoint == 2 ) {
            path.move(to: CGPoint(x: TicTacToeBoardView.bounds.width - 65, y: 70))
        }
        if (startPoint == 3 ) {
            path.move(to: CGPoint(x: 65, y: TicTacToeBoardView.bounds.midY))
        }
        if (startPoint == 6 ) {
            path.move(to: CGPoint(x: 65, y: TicTacToeBoardView.bounds.width - 70))
        }
        
        if (endPoint == 2 ) {
            path.addLine(to: CGPoint(x: TicTacToeBoardView.bounds.width - 65, y: 70))
        }
        if (endPoint == 5 ) {
            path.addLine(to: CGPoint(x: TicTacToeBoardView.bounds.width - 65, y: TicTacToeBoardView.bounds.midY))
        }
        if (endPoint == 6 ) {
            path.addLine(to: CGPoint(x: 65, y: TicTacToeBoardView.bounds.width - 70))
        }
        if (endPoint == 7 ) {
            path.addLine(to: CGPoint(x: TicTacToeBoardView.bounds.midX, y: TicTacToeBoardView.bounds.width - 65))
        }
        if (endPoint == 8 ) {
            path.addLine(to: CGPoint(x: TicTacToeBoardView.bounds.width - 65, y: TicTacToeBoardView.bounds.width - 65))
        }
        
        winningLine.path = path.cgPath
        winningLine.strokeColor = UIColor.systemGreen.withAlphaComponent(0.8).cgColor
        winningLine.lineWidth = 8.0
        TicTacToeBoardView.layer.addSublayer(winningLine)
        startAnimation()
        
    }
    public func startAnimation() {
        // Create a CABasicAnimation to animate the strokeEnd property
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.0
        winningLine.add(animation, forKey: "strokeEnd")
    }
    
    private func rotateTurn() {
        moves += 1
        if turn == Players.player1 {
            turn = Players.player2
        } else {
            turn = Players.player1
            if (mode == Mode.cpu && moves < 9) {
                startTimer()
            }
        }
        
        if (moves > 8) {
            //alert
            let alertController = UIAlertController(title: "Draw", message: "Game Completed", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
                self?.resetGame()
            }
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
        turnBoard.update(player: turn)
    }
    
    @objc private func newGameTapped() {
        resetGame()
        scoreBoard.reset()
    }
    private func startTimer() {
        TicTacToeBoardView.isUserInteractionEnabled = false
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CPUTurn), userInfo: nil, repeats: false)
    }
    
    @objc private func CPUTurn() {
        let range = Array(0...8)
        var totalMoves:[Int] = []
        boardState.indices.forEach { index in
            if (boardState[index] == 1 ||  boardState[index] == 2 ) {
                totalMoves.append(index)
            }
        }
        let uncheckedRange = range.filter {
            if totalMoves.contains($0) {
                return false
            }
            return true
        }
        let randomNumber = uncheckedRange.randomElement()!
        let cell = cell(at: randomNumber)
        if (turn == Players.player2) {
            cell.updateShape(.cross)
        } else {
            cell.updateShape(.circle)
        }
        
        boardState[randomNumber] = 2
        TicTacToeBoardView.backgroundColor = .red.withAlphaComponent(0.3)
        CPUStartTimer()
    }
    
    private func CPUStartTimer() {
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CPUTImerExpired), userInfo: nil, repeats: false)
    }
    @objc private func CPUTImerExpired() {
        TicTacToeBoardView.isUserInteractionEnabled = true
    }
    
    private func cell(at index: Int) -> boardCollectionViewCell {
        let indexpath  = IndexPath(item: index, section: 0)
        let cell = TicTacToeBoardView.cellForItem(at: indexpath) as! boardCollectionViewCell
        return cell
    }
    
    private func resetGame() {
        moves = 0
        boardState = Array(repeating: 0, count: 9)
        uncheckedRange.removeAll()
        winningLine.removeFromSuperlayer()
        TicTacToeBoardView.reloadData()
    }
    
    private func checkWinCondition(for player: Players) {
        // Setting Win conditions
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        var playerMoves:[Int] = []
        
        boardState.indices.forEach { index in
            if player == Players.player1 {
                if boardState[index] == 1 {
                    playerMoves.append(index)
                }
            } else {
                if boardState[index] == 2 {
                    playerMoves.append(index)
                }
            }
        }
        
        //  If player move == a win condition, then win
        for pattern in winPatterns where pattern.isSubset(of: playerMoves) {
            scoreBoard.incrementScoreFor(turn)
            drawWinningLine(pattern: pattern)
            let alertController = UIAlertController(title: "\(player) WON!", message: "Game Completed", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Next round", style: .cancel) { [weak self] _ in
                self?.resetGame()
            }
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
        
    }
}

extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: boardCollectionViewCell.identifier, for: indexPath) as! boardCollectionViewCell
        switch boardState[indexPath.item] {
        case 1:
            cell.updateShape(.cross)
        case 2:
            cell.updateShape(.circle)
        default:
            cell.updateShape(.empty)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! boardCollectionViewCell
        if (!cell.isSelected()) {
            if (turn == Players.player1) {
                boardState[indexPath.item] = 1
                cell.updateShape(.cross)
                TicTacToeBoardView.backgroundColor = .systemGray4
            } else {
                boardState[indexPath.item] = 2
                cell.updateShape(.circle)
                TicTacToeBoardView.backgroundColor = .red.withAlphaComponent(0.3)
            }
            checkWinCondition(for: turn)
            rotateTurn()
        } else {
            let alertController = UIAlertController(title: "Select valid cell", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(cancelAction)
            present(alertController, animated: true)
        }
        if (mode == Mode.cpu && moves < 9) {
            //take turn for cpu is remains.
            rotateTurn()
        }
    }
}

extension ViewController:modeViewDelegate {
    func modeUpdate(mode: Mode) {
        self.mode = mode
        resetGame()
    }
}


