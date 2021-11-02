//
//  UIApplication+stopShowingKeyboard.swift
//  CookConversion
//
//  Created by Gabriel on 11/2/21.
//

import SwiftUI

extension UIApplication {
    func stopShowingKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
