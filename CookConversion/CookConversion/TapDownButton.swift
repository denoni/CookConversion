//
//  TapDownButton.swift
//  CookConversion
//
//  Created by Gabriel on 11/1/21.
//

import SwiftUI

struct TapDownButton: View {
  var text: String

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 19, style: .continuous)
        .foregroundColor(.white)
      HStack {
        Text(text)
          .fontWeight(.semibold)
          .padding(.leading, 20)
          .padding(.trailing, 10)
        Spacer()
        Rectangle()
          .foregroundColor(.black.opacity(0.2))
          .frame(width: 2)
          .frame(maxHeight: .infinity)
        Image(systemName: "chevron.down")
          .scaledToFit()
          .padding(.trailing, 10)
      }
    }
  }
}
