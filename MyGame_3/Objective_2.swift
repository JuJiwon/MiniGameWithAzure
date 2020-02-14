
import UIKit

class Objective_2: UIView {
    
    var color_2: Bool = true
    
    weak open var delegate: ViewDelegate_2?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.delegate?.myFunc_()
        
    }
    
}


protocol ViewDelegate_2 : class {
    
    func myFunc_()
    
}

