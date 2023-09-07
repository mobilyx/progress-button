//
//  CircularProgressBarView.swift
//  progressButton
//
//  Created by Arslan Raza on 06/09/2023.
//

import Foundation
import UIKit

public typealias AnimationCompletionHandler = (Bool) -> Void
public class CircularProgressBarView: UIButton {
    
    var completionHandler: AnimationCompletionHandler?

    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var initialProgressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func createCircularPath() {

        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 12, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        
        circleLayer.path = circularPath.cgPath
        setButtonImage(systemImage: "play.fill", size: 15)
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 20.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.clear.cgColor
        layer.addSublayer(circleLayer)
        
        initialProgressLayer.path = circularPath.cgPath
        initialProgressLayer.fillColor = UIColor.clear.cgColor
        initialProgressLayer.lineCap = .round
        initialProgressLayer.lineWidth = 3.0
        initialProgressLayer.strokeEnd = 0
        initialProgressLayer.strokeColor = UIColor.lightGray.cgColor
        layer.addSublayer(initialProgressLayer)
        subProgressAnimation()
        
        progressLayer.path = circularPath.cgPath
        // ui edits
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 3.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.systemBlue.cgColor
        // added progressLayer to layer
        layer.addSublayer(progressLayer)
    }
    
    public func progressAnimation(duration: TimeInterval, completionHandler: @escaping AnimationCompletionHandler) {
        // created circularProgressAnimation with keyPath
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.delegate = self
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        self.completionHandler = completionHandler
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
    
    public func subProgressAnimation() {
        // created circularProgressAnimation with keyPath
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        // set the end time
        circularProgressAnimation.duration = 0
        circularProgressAnimation.toValue = 1.0
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        initialProgressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
    
    public func stopAnimation() {
        progressLayer.removeAnimation(forKey: "progressAnim")
    }
    
    public func isProgressAnimationRunning() -> Bool {
        if let animation = progressLayer.animation(forKey: "progressAnim") {
            // Check if the animation is not removed on completion
            return !animation.isRemovedOnCompletion
        }
        return false
    }
    
    public func setButtonImage(systemImage: String, size: Int) {
        let buttonConfig = UIImage.SymbolConfiguration(pointSize: 15, weight: .regular, scale: .small)
        let stopImage = UIImage(systemName: systemImage, withConfiguration: buttonConfig)
        self.setImage(stopImage, for: .normal)
    }
}


extension CircularProgressBarView: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            completionHandler?(true)
        } else {
            completionHandler?(false)
        }
    }
}
