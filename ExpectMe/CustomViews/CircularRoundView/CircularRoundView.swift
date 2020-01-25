import UIKit

class CircularRoundView: UIView {
    
    override var bounds: CGRect {
        get {
            return super.bounds
        }
        set {
            super.bounds = newValue
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = bounds.height / 2.0
        self.layer.masksToBounds = true        
    }
}
