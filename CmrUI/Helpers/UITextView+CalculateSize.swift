//
//  UITextView+CalculateSize.swift
//  CmrUI
//

import UIKit

extension UIFont {
    func sizeOfString (string: String, constrainedToWidth width: CGFloat) -> CGSize {
        return NSString(string: string).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                     attributes: [NSAttributedStringKey.font: self],
                                                     context: nil).size
    }
}

extension UITextView {
    func calculateMaxFontSizeForTextView(frameTextView: CGRect) -> CGFloat {
        var fontDecrement = self.font?.pointSize
        let textView = UITextView.init()
        textView.text = self.text
        
        if (textView.contentSize.height > frameTextView.size.height) {
            while (textView.contentSize.height > frameTextView.size.height) {
                textView.font = UIFont.systemFont(ofSize: fontDecrement!)
                fontDecrement = fontDecrement! - 1
            }
        }
        if let fontDecrement = fontDecrement {
            return fontDecrement
        }
        return 17.0
    }
}
