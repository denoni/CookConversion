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
      .keyboardType(.numberPad)
      .font(.title2.weight(.heavy))
      .foregroundColor(.black)
      .padding(Constants.smallPadding)
      .multilineTextAlignment(.center)
      .onReceive(Just(textInput)) { _ in limitText(4) }
  }

  private struct PlaceholderStyle: ViewModifier {
    var showPlaceHolder: Bool
    var placeholderText: String

    public func body(content: Content) -> some View {
      ZStack(alignment: .center) {
        if showPlaceHolder {
          Text(placeholderText)
            .foregroundColor(Color.black.opacity(0.3))
        }
        content
      }
    }
  }

  // to keep text length in limits
  private func limitText(_ characterLimit: Int) {
    if textInput.count > characterLimit {
      textInput = String(textInput.prefix(characterLimit))
    }
  }
}
