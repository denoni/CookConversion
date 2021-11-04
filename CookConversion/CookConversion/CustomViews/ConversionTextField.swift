//
//  ConversionTextField.swift
//  CookConversion
//
//  Created by Gabriel on 11/2/21.
//

import SwiftUI
import Combine

struct ConversionTextField: View {
  @Binding var textInput: String
  var placeholderText: String

  var body: some View {
    TextField("", text: $textInput)
      .modifier(PlaceholderStyle(showPlaceHolder: textInput.isEmpty, placeholderText: placeholderText))
      .keyboardType(.decimalPad)
      .font(.title2.weight(.heavy))
      .foregroundColor(.blackDarkSensitive)
      .padding(Constants.smallPadding)
      .multilineTextAlignment(.center)
  }

  private struct PlaceholderStyle: ViewModifier {
    var showPlaceHolder: Bool
    var placeholderText: String

    public func body(content: Content) -> some View {
      ZStack(alignment: .center) {
        if showPlaceHolder {
          Text(placeholderText)
            .foregroundColor(Color.blackDarkSensitive.opacity(0.3))
        }
        content
      }
    }
  }

}
