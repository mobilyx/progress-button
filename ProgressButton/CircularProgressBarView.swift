//
//  CircularProgressBarView.swift
//  progressButton
//
//  Created by Arslan Raza on 06/09/2023.
//

import Foundation
import UIKit

public typealias AnimationCompletionHandler = (Bool) -> Void
public class CircularProgressView: UIControl {
    
    var completionHandler: AnimationCompletionHandler?

    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var initialProgressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    @IBInspectable public var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    @IBInspectable public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable public var imageTintColor: UIColor = .blue {
        didSet {
            imageView.tintColor = imageTintColor
        }
    }

    @IBInspectable public var titleColor: UIColor = .black {
        didSet {
            titleLabel.textColor = titleColor
        }
    }

    @IBInspectable public var titleFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    @IBInspectable public var imageHeight: CGFloat = 0.0 {
        didSet {
            updateImageSize()
        }
    }

    @IBInspectable public var imageWidth: CGFloat = 0.0 {
        didSet {
            updateImageSize()
        }
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func updateImageSize() {
        let imageSize = CGSize(width: imageWidth, height: imageHeight)
        imageView.frame = CGRect(x: (bounds.width - imageSize.width) / 2,
                                 y: (bounds.height - imageSize.height) / 2,
                                 width: imageSize.width,
                                 height: imageSize.height)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        updateImageSize()
        titleLabel.frame = CGRect(x: 0, y: bounds.height * 0.75, width: bounds.width, height: bounds.height * 0.25)
        imageView.tintColor = imageTintColor
        titleLabel.textColor = titleColor
        titleLabel.font = titleFont
    }
    
    public func setImage(_ image: UIImage?, withRenderingMode renderingMode: UIImage.RenderingMode) {
        imageView.image = image?.withRenderingMode(renderingMode)
    }

    public func setTitleText(_ text: String?, withFont font: UIFont) {
        titleLabel.text = text
        titleLabel.font = font
    }
    
    public func createCircularPath(radius: CGFloat, lineWidth: CGFloat, strokeInitialColor: UIColor, strokeFillColor: UIColor) {

        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: radius, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 20.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.clear.cgColor
        layer.addSublayer(circleLayer)
        
        initialProgressLayer.path = circularPath.cgPath
        initialProgressLayer.fillColor = UIColor.clear.cgColor
        initialProgressLayer.lineCap = .round
        initialProgressLayer.lineWidth = lineWidth
        initialProgressLayer.strokeEnd = 0
        initialProgressLayer.strokeColor = strokeInitialColor.cgColor//UIColor.lightGray.cgColor
        layer.addSublayer(initialProgressLayer)
        subProgressAnimation()
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = lineWidth
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = strokeFillColor.cgColor//UIColor.systemBlue.cgColor
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
}


extension CircularProgressView: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            completionHandler?(true)
        } else {
            completionHandler?(false)
        }
    }
}
