//
//  ViewController.swift
//  MovieApp
//
//  Created by Чебупелина on 01.08.2023.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.frame.size = CGSize(width: 100, height: 100)
        button.setTitle("get Data", for: .normal)
        button.setTitleColor(.red, for: .normal)
        let bounds = UIScreen.main.bounds
        button.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        button.addTarget(self, action: #selector(buttonDidTap), for: .touchUpInside)
        view.addSubview(button)
        setupUI()
    }

    @objc
    private func buttonDidTap() {
        let url = URL(string: Links.Films.films)!
        print("url: ", url)
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.appBackground
        setupNavItem()
    }
    
    private func setupNavItem() {
        let width = UIScreen.main.bounds.width
        let height: CGFloat = 50
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        let stringNight = NSAttributedString(string: "Night", attributes: [.foregroundColor: AppColors.lightGray, .font: UIFont.systemFont(ofSize: 25, weight: .heavy)])
        let stringBurgerus = NSAttributedString(string: "Burgerus", attributes: [.foregroundColor: AppColors.lightRed, .font: UIFont.systemFont(ofSize: 25, weight: .heavy)])
        let resultString = NSMutableAttributedString(attributedString: stringNight)
        resultString.append(stringBurgerus)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        label.attributedText = resultString
        label.sizeToFit()
        label.center.y = CGFloat(height / 2)
        titleView.addSubview(label)
        
        let searchButtonView = UIView()
        let searchButtonRect = CGRect(x: titleView.bounds.width - height, y: 0, width: height * 0.7, height: height * 0.7)
        searchButtonView.frame = searchButtonRect
        searchButtonView.center.y = titleView.center.y
        
        let searchFrame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let searchPath = UIBezierPath()
        searchPath.addArc(withCenter: CGPoint(x: 10, y: 10), radius: 10, startAngle: CGFloat.pi / 4, endAngle: CGFloat.pi / 4 + 0.01, clockwise: false)
        searchPath.addLine(to: CGPoint(x: 25, y: 25))
        searchPath.close()
        
        let searchLayer = CAShapeLayer()
        searchLayer.path = searchPath.cgPath
        searchLayer.strokeColor = AppColors.lightGray.cgColor
        searchLayer.lineWidth = 3
        searchLayer.fillColor = UIColor.clear.cgColor
        searchButtonView.layer.addSublayer(searchLayer)
        searchButtonView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(searchDidTap))
        searchButtonView.addGestureRecognizer(tap)
        
        titleView.addSubview(searchButtonView)
        
        navigationItem.titleView = titleView
    }
    
    @objc
    private func searchDidTap() {
        print("search tapped")
    }
}

