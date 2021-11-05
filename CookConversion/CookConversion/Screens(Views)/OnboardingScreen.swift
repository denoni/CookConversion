//
//  OnboardingScreen.swift
//  CookConversion
//
//  Created by Gabriel on 11/4/21.
//

import SwiftUI

struct OnboardingScreen: View {
  @EnvironmentObject var cookConversionViewModel: CookConversionViewModel
  @State var currentTab = 0

  var body: some View {
    ZStack {
      TabView(selection: $currentTab) {
        Text("ABC").font(.title).tag(0)
        Image(systemName: "gear").tag(1)
        Text("").tag(2)
          .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
              cookConversionViewModel.isShowingOnboardingScreen = false
            }
          }
      }
      .tabViewStyle(.page(indexDisplayMode: .always))
    }
    .ignoresSafeArea()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.lightGray)
  }
}
