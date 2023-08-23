//
//  MapInfoViewController.swift
//  GeoLocation
//
//  Created by Vaibhav Raikwar on 13/07/23.
//
import UIKit

protocol MapInfoViewDelegate: NSObject {
    func showUniversities()
    func navigate()
}

class MapInfoView: UIView{
    
    weak var delegate: MapInfoViewDelegate?

    let showUniversities = UIButton()
    let navigate = UIButton()
    var title = UILabel()
    var subTitle1 = UILabel()
    var subTitle2 = UILabel()
    var subTitle3 = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.layer.cornerRadius = 16
        
        self.addSubview(showUniversities)
        showUniversities.translatesAutoresizingMaskIntoConstraints = false
        showUniversities.addTarget(self, action: #selector(universitiesTapped), for: .touchUpInside)
        showUniversities.setTitle("Show Universities", for: .normal)
        showUniversities.setTitleColor(.tintColor, for: .normal)
        showUniversities.layer.cornerRadius = 16
        showUniversities.backgroundColor = .systemGray3.withAlphaComponent(0.8)
        showUniversities.clipsToBounds = true
        
        self.addSubview(navigate)
        navigate.translatesAutoresizingMaskIntoConstraints = false
        navigate.addTarget(self, action: #selector(navigateTapped), for: .touchUpInside)
        navigate.setTitle("Navigate", for: .normal)
        navigate.setTitleColor(.tintColor, for: .normal)
        navigate.layer.cornerRadius = 16
        navigate.backgroundColor = .systemGray3.withAlphaComponent(0.8)
        navigate.clipsToBounds = true
        
        self.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = UIColor.tintColor
        title.font = UIFont.boldSystemFont(ofSize: 30)
        title.frame = self.bounds
        
        self.addSubview(subTitle1)
        subTitle1.translatesAutoresizingMaskIntoConstraints = false
        subTitle1.textColor = UIColor.label.withAlphaComponent(0.8)
        subTitle1.font = UIFont.systemFont(ofSize: 24)
        
        self.addSubview(subTitle2)
        subTitle2.translatesAutoresizingMaskIntoConstraints = false
        subTitle2.textColor = UIColor.label.withAlphaComponent(0.6)
        subTitle2.font = UIFont.systemFont(ofSize: 16)
        
        self.addSubview(subTitle3)
        subTitle3.translatesAutoresizingMaskIntoConstraints = false
        subTitle3.textColor = UIColor.tintColor.withAlphaComponent(0.9)
        subTitle3.font = UIFont.systemFont(ofSize: 16)
        
        NSLayoutConstraint.activate([
            showUniversities.topAnchor.constraint(equalTo: self.topAnchor),
            showUniversities.heightAnchor.constraint(equalToConstant: 40),
            showUniversities.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 10),
            
            navigate.topAnchor.constraint(equalTo: self.topAnchor),
            navigate.heightAnchor.constraint(equalToConstant: 40),
            navigate.leadingAnchor.constraint(equalTo: showUniversities.trailingAnchor,constant: 10),
            navigate.widthAnchor.constraint(equalToConstant: 140),
            navigate.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            
            title.topAnchor.constraint(equalTo: showUniversities.bottomAnchor, constant: 0),
            title.heightAnchor.constraint(equalToConstant: 100),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            subTitle1.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 0),
            subTitle1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            subTitle1.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            subTitle1.heightAnchor.constraint(equalToConstant: 30),
            
            subTitle2.topAnchor.constraint(equalTo: subTitle1.bottomAnchor, constant: 0),
            subTitle2.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            subTitle2.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            subTitle2.heightAnchor.constraint(equalToConstant: 30),
            
            subTitle3.topAnchor.constraint(equalTo: subTitle2.bottomAnchor, constant: 0),
            subTitle3.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            subTitle3.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            subTitle3.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    public func setTextFor(title: String, subTitle1: String, subTitle2: String, subTitle3: String ) {
        self.title.text = title
        self.subTitle1.text = subTitle1
        self.subTitle2.text = subTitle2
        self.subTitle3.text = subTitle3
    }
    
    public func setDistance(_ distance: Double, travelTime: Double) {
        self.subTitle3.text = "Distance: \((distance/1000).rounded()) Km, Travel time: \((travelTime/86400).rounded()) Hrs"
    }
    
    @objc func universitiesTapped() {
        self.delegate?.showUniversities()
    }
    
    @objc func navigateTapped() {
        self.delegate?.navigate()
    }
}
