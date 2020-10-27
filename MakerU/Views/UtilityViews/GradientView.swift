import UIKit

class GradientView: UIView {
    
    let startColor = UIColor(white: 0, alpha: 0.7)
    let endColor = UIColor(white: 0, alpha: 0)
    let startLocation: NSNumber = 1.0
    let midLocation: NSNumber = 0.5
    let endLocation: NSNumber = 0.0
    let gradient = CAGradientLayer()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.9)
        gradient.frame = bounds
        layer.addSublayer(gradient)
        layer.cornerRadius = 10
    }
}
