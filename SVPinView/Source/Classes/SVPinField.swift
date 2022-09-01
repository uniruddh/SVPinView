//
//  SVPinField.swift
//  SVPinView
//
//  Created by Srinivas Vemuri on 20/04/18.
//  Copyright © 2018 Xornorik. All rights reserved.
//

import UIKit

class SVPinField: UITextField {
    var deleteButtonAction: SVPinViewDeleteButtonAction = .deleteCurrentAndMoveToPrevious
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override func deleteBackward() {
        
        let isBackSpace = { () -> Bool in
            let char = self.text!.cString(using: String.Encoding.utf8)!
            return strcmp(char, "\\b") == -92
        }
        
        switch deleteButtonAction {
        case .deleteCurrentAndMoveToPrevious:
            // Move cursor from the beginning (set in shouldChangeCharIn:) to the end for deleting
            selectedTextRange = textRange(from: endOfDocument, to: beginningOfDocument)
            super.deleteBackward()
            
            if isBackSpace(), let nextResponder = self.superview?.superview?.superview?.superview?.viewWithTag(self.tag - 1) as UIResponder? {
                nextResponder.becomeFirstResponder()
            }
        case .deleteCurrent:
            if !(text?.isEmpty ?? true) {
                super.deleteBackward()
            } else {
                // Move cursor from the beginning (set in shouldChangeCharIn:) to the end for deleting
                selectedTextRange = textRange(from: endOfDocument, to: beginningOfDocument)
                
                if isBackSpace(), let nextResponder = self.superview?.superview?.superview?.superview?.viewWithTag(self.tag - 1) as UIResponder? {
                    nextResponder.becomeFirstResponder()
                }
            }
        case .moveToPreviousAndDelete:
            if let nextResponder = self.superview?.superview?.superview?.superview?.viewWithTag(self.tag - 1) as UIResponder? {
                nextResponder.becomeFirstResponder()
            }
        }
    }
}
