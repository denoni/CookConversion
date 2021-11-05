//
//  MainScreen.swift
//  CookConversion
//
//  Created by Gabriel on 11/1/21.
//

import SwiftUI

struct MainScreen: View {
  var body: some View {
    ZStack {
      Color.lightGray
      VStack(spacing: 0) {
        TopSelectionSection()
        ConversionResponses()
        UserInputSection()
      }
    }
    .ignoresSafeArea()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}



struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainScreen()
  }
}
