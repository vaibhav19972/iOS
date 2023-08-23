import UIKit

protocol modeViewDelegate: NSObject {
    func modeUpdate(mode: Mode)
}

class modeView: UIView {
    
    weak var delegate: modeViewDelegate?
    
    let CPU = UIButton()
    let VS = UIButton()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.addSubview(CPU)
        CPU.translatesAutoresizingMaskIntoConstraints = false
        CPU.setTitle("  CPU  ", for: .normal)
        CPU.setTitleColor(.brown.withAlphaComponent(0.8), for: .normal)
        CPU.addTarget(self, action: #selector(CPUTapped), for: .touchUpInside)
        CPU.contentVerticalAlignment = .fill
        CPU.contentHorizontalAlignment = .fill
        
        self.addSubview(VS)
        VS.translatesAutoresizingMaskIntoConstraints = false
        VS.setTitle("    VS    ", for: .normal)
        VS.addTarget(self, action: #selector(VSTapped), for: .touchUpInside)
        VS.backgroundColor = .systemGray3.withAlphaComponent(0.8)
        VS.setTitleColor(.brown.withAlphaComponent(0.8), for: .normal)
        VS.contentVerticalAlignment = .fill
        VS.contentHorizontalAlignment = .fill
        
        NSLayoutConstraint.activate([
            VS.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            VS.heightAnchor.constraint(equalToConstant: 60),
            VS.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 65),
            
            CPU.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            CPU.heightAnchor.constraint(equalToConstant: 60),
            CPU.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
        ])
    }
    
    
    @objc func CPUTapped() {
        delegate?.modeUpdate(mode: Mode.cpu)
        CPU.backgroundColor = .systemGray3.withAlphaComponent(0.8)
        VS.backgroundColor = .clear
    }
    @objc func VSTapped() {
        delegate?.modeUpdate(mode: Mode.vs)
        VS.backgroundColor = .systemGray3.withAlphaComponent(0.8)
        CPU.backgroundColor = .clear
    }
}

