import UIKit

class GradientView: UIView {
    
    let startColor = UIColor(white: 1.0, alpha: 0)
    var endColor = UIColor(white: 0, alpha: 0.2)
    let startLocation: NSNumber = 1.0
    let midLocation: NSNumber = 0.6
    let endLocation: NSNumber = 0.0
    let gradient = CAGradientLayer()
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        gradient.colors    = [endColor.cgColor, startColor.cgColor]
        gradient.locations = [startLocation, endLocation]
        gradient.frame = bounds
        layer.addSublayer(gradient)
        layer.cornerRadius = 10
    }
}
