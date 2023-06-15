//
//  PaddingLabel.swift
//  AR Doctor
//
//  Created by Qian-Yu Du on 2023/5/4.
//

import Foundation
import UIKit

@IBDesignable
class PaddingLabel: UILabel {
    private var padding = UIEdgeInsets.zero
    
    @IBInspectable
    var localisedKey: String? {
        didSet {
            guard let key = localisedKey else { return }
            text = NSLocalizedString(key, comment: "")
        }
    }
    
    @IBInspectable
    var paddingLeft: CGFloat {
        get { return padding.left }
        set { padding.left = newValue }
    }
    
    @IBInspectable
    var paddingRight: CGFloat {
        get { return padding.right }
        set { padding.right = newValue }
    }
    
    @IBInspectable
    var paddingTop: CGFloat {
        get { return padding.top }
        set { padding.top = newValue }
    }
    
    @IBInspectable
    var paddingBottom: CGFloat {
        get { return padding.bottom }
        set { padding.bottom = newValue }
    }
    
    override func drawText(in rect: CGRect) {
        //        print("drawText")
        super.drawText(in: rect.inset(by: padding))
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) ->
        CGRect {
            let insets = self.padding
            var rect = super.textRect(forBounds: bounds.inset(by: insets), limitedToNumberOfLines: numberOfLines)
            rect.origin.x    -= insets.left
            rect.origin.y    -= insets.top
            rect.size.width  += (insets.left + insets.right)
            rect.size.height += (insets.top + insets.bottom)
            return rect
    }
}
