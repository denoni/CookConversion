//
//  MainScreen.swift
//  CookConversion
//
//  Created by Gabriel on 11/1/21.
//

import SwiftUI

struct MainScreen: View {
  var body: some View {
    GeometryReader { geo in
      ZStack {
        VStack(spacing: 0) {
          Color.skyBlue
            .frame(height: geo.safeAreaInsets.top)
          Color.lightGray
          Color.whiteDarkSensitive
            .frame(height: geo.safeAreaInsets.bottom)
        }
        .ignoresSafeArea()
        VStack(spacing: 0) {
          TopSelectionSection()
          ConversionResponses()
          UserInputSection()
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}



struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainScreen()
  }
}
