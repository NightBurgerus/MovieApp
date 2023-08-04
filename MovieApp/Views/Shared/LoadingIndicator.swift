//
//  LoadingIndicator.swift
//  MovieApp
//
//  Created by Чебупелина on 01.08.2023.
//

import Foundation
import UIKit

class LoadingIndicator: UIView {
    private let size: CGSize
    private let lineWidth: CGFloat = 7
    private var circle: UIView!
    private var fillingCircleLayer: CAShapeLayer!
    private var background: UIView!
    
    override init(frame: CGRect) {
        let screenWidth = UIScreen.main.bounds.width
        self.size = CGSize(width: screenWidth / 7, height: screenWidth / 7)
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        self.draw(frame)
    }
    
    func stop() {
        let circle = fillingCircle()
        self.addSubview(circle)
        self.circle.layer.opacity = 0
        UIView.animate(withDuration: 0.5, delay: 0.5) {
            circle.layer.opacity = 0
            self.background.layer.opacity = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            circle.removeFromSuperview()
            self.circle.removeFromSuperview()
            self.background.removeFromSuperview()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let bounds = UIScreen.main.bounds
        self.background = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        background.backgroundColor = UIColor.black
        background.layer.opacity = 0.5
        
        drawСircle()
        
        self.circle = drawDashedСircle()
        
        self.addSubview(background)
        self.addSubview(circle)
        animateCircle()
    }
    
    private func drawDashedСircle() -> UIView {
        let circleView = UIView()
        let bounds = UIScreen.main.bounds
        
        circleView.frame.size = size
        let center = CGPoint(x: bounds.midX, y: bounds.midY - circleView.frame.height)
        circleView.center = center
        var rect = CGRect()
        rect.size = self.size
        
        let circlePath = UIBezierPath(ovalIn: rect)
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = AppColors.lightRed.cgColor
        circleLayer.lineWidth = lineWidth
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineDashPattern = [3.14, 9.42]
        
        circleView.layer.addSublayer(circleLayer)
        
        return circleView
    }
    
    private func animateCircle() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = NSNumber(value: 0)
        animation.toValue = NSNumber(value: 360*CGFloat.pi/180)
        animation.duration = 2
        animation.repeatCount = 1e100
        self.circle.layer.add(animation, forKey: "circle.rotation")
    }
    
    private func drawСircle(){
        let circleView = UIView()
        let bounds = UIScreen.main.bounds
        circleView.frame.size = size
        let origin = CGPoint(x: bounds.width / 2 - size.width / 2, y: 0)
        circleView.frame.origin = origin
        var rect = CGRect()
        rect.size = self.size
        
        let circlePath = UIBezierPath(ovalIn: rect)
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = AppColors.lightRed.cgColor
        circleLayer.lineWidth = lineWidth
        circleLayer.fillColor = UIColor.clear.cgColor
            
        self.fillingCircleLayer = circleLayer
    }
    
    private func fillingCircle() -> UIView {
        let circleView = UIView()
        let bounds = UIScreen.main.bounds
        circleView.frame.size = size
        
        let origin = CGPoint(x: bounds.width / 2 - size.width / 2, y: bounds.midY - circleView.frame.height * 1.5)
        circleView.frame.origin = origin
        
        fillingCircleLayer.strokeEnd = 0

        circleView.layer.addSublayer(fillingCircleLayer)

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        fillingCircleLayer.strokeEnd = 1
        fillingCircleLayer.add(animation, forKey: "animateCircle")
        
        circleView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.duration = 1
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * CGFloat.pi
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        circleView.layer.add(rotationAnimation, forKey: "rotate")
        
        return circleView
    }
}
