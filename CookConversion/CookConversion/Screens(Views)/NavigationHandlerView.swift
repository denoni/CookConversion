//
//  NavigationHandlerView.swift
//  CookConversion
//
//  Created by Gabriel on 11/4/21.
//

import SwiftUI

struct NavigationHandlerView: View {
  @EnvironmentObject var cookConversionViewModel: CookConversionViewModel

  var body: some View {
    if cookConversionViewModel.isShowingOnboardingScreen {
      OnboardingScreen()
    } else {
      MainView()
    }
  }
}
