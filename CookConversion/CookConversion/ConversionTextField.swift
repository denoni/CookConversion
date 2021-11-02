//
//  ConversionTextField.swift
//  CookConversion
//
//  Created by Gabriel on 11/2/21.
//

import SwiftUI

struct ConversionTextField: View {
  @Binding var textInput: String
  var placeholderText: String

  var body: some View {
    TextField("", text: $textInput)
      .modifier(PlaceholderStyle(showPlaceHolder: textInput.isEmpty, placeholderText: placeholderText))
      .font(.title2.weight(.heavy))
      .padding(.horizontal, 5)
      .foregroundColor(.black)
      .padding(.vertical, 10)
      .padding(.horizontal, 15)
  }

  private struct PlaceholderStyle: ViewModifier {
      var showPlaceHolder: Bool
      var placeholderText: String

      public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
          if showPlaceHolder {
            Text(placeholderText)
              .padding(.horizontal, 5)
              .foregroundColor(Color.black.opacity(0.3))
          }
          content
      }
    }
  }
}
