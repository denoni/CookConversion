//
//  TopSelectionSection.swift
//  CookConversion
//
//  Created by Gabriel on 11/5/21.
//

import SwiftUI

struct TopSelectionSection: View {
  @EnvironmentObject var cookConversionViewModel: CookConversionViewModel
  @ObservedObject private var keyboardResponder = KeyboardResponder()
  @Environment(\.topSafeAreaSize) var topSafeAreaSize
  @State var settingsScreenIsOpen = false

  var body: some View {
    ZStack {
      Rectangle()
        .foregroundColor(Color.skyBlue)
        .cornerRadius(Constants.bigRadius, corners: [.bottomLeft, .bottomRight])
      VStack {
        TopButtonsBar(settingsScreenIsOpen: $settingsScreenIsOpen)
        HStack(alignment: .bottom, spacing: Constants.smallPadding) {
          TapDownButton(measurementType: .preciseMeasure)
            .accessibilityHint("Tap to open a list of possible input measures to choose.")
            .accessibility(sortPriority: 3)
          TapDownButton(measurementType: .commonMeasure)
            .accessibilityHint("Tap to open a list of possible output measures to choose.")
            .accessibility(sortPriority: 3)
        }
        .frame(height: Constants.bigButtonHeight)
        .padding(Constants.standardPadding)
      }
      .frame(maxHeight: .infinity)
      .padding(.top, topSafeAreaSize + Constants.standardPadding)
    }
    .ignoresSafeArea()
    .frame(height: topSafeAreaSize + 150)
    // Need this negative padding otherwise this view will move up when keyboard opens
    .padding(.bottom, -keyboardResponder.currentHeight)
    // If user taps in some view(that's not a tappable item), close keyboard and menus
    .onTapGesture { UIApplication.shared.stopShowingKeyboard() }
    .sheet(isPresented: $settingsScreenIsOpen,
           onDismiss: { cookConversionViewModel.updateCurrentSelectedMeasures() }) {
      SettingsView()
    }
  }

  fileprivate struct TopButtonsBar: View {
    @Binding var settingsScreenIsOpen: Bool
    var body: some View {
      HStack {
        Spacer()
        Button(action: {
          settingsScreenIsOpen = true
        }, label: {
          Image(systemName: "gear")
            .resizable()
            .renderingMode(.template)
            .foregroundColor(.white)
            .frame(width: 25, height: 25)
        })
      }
      .padding(.horizontal, Constants.standardPadding)
    }
  }

}
