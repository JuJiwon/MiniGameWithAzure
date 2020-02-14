
import UIKit

class Objective_1: UIView {
    
    var mmA = 0.1
    
    var width, height: CGFloat!
    
    //
    var timerif = true
    //
    
    weak open var delegate: ViewDelegate_1?
    var timer = Timer()
    var color_1: Bool = true
    var y: Double = 50
    
    
    override func draw(_ rect: CGRect) {
        if timerif == true {
            timer = Timer.scheduledTimer(timeInterval: 0.00054, target: self, selector: Selector(("activeTimer")), userInfo: nil, repeats: true)
            timerif = false
        }
        
    }
    
    
    @objc func activeTimer() {
        self.y += mmA
        self.center = CGPoint(x: Double(width/2), y: self.y)
        if height-100 <= self.frame.origin.y + 15 {
            self.delegate?.myFunc()
            y = Double(height/18)
        }
        
    }
    
}




protocol ViewDelegate_1 : class {
    func myFunc()
}



