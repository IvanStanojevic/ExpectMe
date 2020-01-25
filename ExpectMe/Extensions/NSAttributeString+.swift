import UIKit

extension NSMutableAttributedString {
    /**Makes an attributes string with the specified (plain) string and font but resizes the font smaller
     to fit the width if required. Can return nil, if there is no way to make it fit*/
    convenience init?(string : String, font : UIFont, maxWidth : CGFloat){
        self.init()
        for size in (0 ..< NSInteger(font.pointSize)).reversed() {
            let attrs = [NSAttributedString.Key.font: font.withSize(CGFloat(size))]
            let attrString = NSAttributedString(string: string, attributes: attrs)
            if attrString.size().width <= maxWidth {
                self.setAttributedString(attrString)
                return
            }
        }
        return nil
    }
}



public func += ( left: inout NSMutableAttributedString, right: NSAttributedString) {
    left.append(right)
}

public func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let result  = NSMutableAttributedString(attributedString: right)
    result.append(right)
    return result
}

public func + (left: NSAttributedString, right: String) -> NSAttributedString {
    let result  = NSMutableAttributedString(attributedString: left)
    result.append(NSAttributedString(string: right))
    return result
}
