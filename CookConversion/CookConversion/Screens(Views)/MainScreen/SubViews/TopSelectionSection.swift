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
  @State var settingsScreenIsOpen = false

  private var outputMeasureType: CookConversionModel.MeasurementType {
    if cookConversionViewModel.inputMeasureType == .preciseMeasure {
      return .commonMeasure
    } else {
      return .preciseMeasure
    }
  }

  var body: some View {
    ZStack {
      Rectangle()
        .foregroundColor(Color.skyBlue)
        .cornerRadius(Constants.bigRadius, corners: [.bottomLeft, .bottomRight])
      VStack {
        TopButtonsBar(settingsScreenIsOpen: $settingsScreenIsOpen)
        HStack(alignment: .bottom, spacing: Constants.smallPadding) {
          TapDownButton(measurementType: cookConversionViewModel.inputMeasureType)
            .accessibilityHint("Tap to open a list of possible input measures to choose.")
            .accessibility(sortPriority: 3)
            .accessibilityIdentifier("inputMeasureButton")
          TapDownButton(measurementType: outputMeasureType)
            .accessibilityHint("Tap to open a list of possible output measures to choose.")
            .accessibility(sortPriority: 3)
            .accessibilityIdentifier("resultMeasureButton")
        }
        .frame(height: Constants.bigButtonHeight)
        .padding(Constants.standardPadding)
      }
      .frame(maxHeight: .infinity)
      .padding(.top, Constants.standardPadding)
    }
    .frame(height: 150)
    // Need this negative padding otherwise this view will move up when keyboard opens
    .padding(.bottom, -keyboardResponder.currentHeight)
    // If user taps in some view(that's not a tappable item), close keyboard and menus
    .onTapGesture { UIApplication.shared.stopShowingKeyboard() }
    .zIndex(1)
    .sheet(isPresented: $settingsScreenIsOpen,
           onDismiss: { cookConversionViewModel.updateCurrentSelectedMeasures() }) {
      SettingsView()
    }
  }

  fileprivate struct TopButtonsBar: View {
    @EnvironmentObject var cookConversionViewModel: CookConversionViewModel
    @Binding var settingsScreenIsOpen: Bool

    @State private var buttonRotation: Double = 0

    var body: some View {
      HStack {
        // An empty view with 25 width to make the reverse button bellow be centralized
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 25)
        Spacer()
        ReverseOrderButton(buttonRotation: $buttonRotation)
        Spacer()
        SettingsButton(settingsScreenIsOpen: $settingsScreenIsOpen)
          .accessibilityIdentifier("settingsButton")
      }
      .padding(.horizontal, Constants.standardPadding)
    }

    private struct ReverseOrderButton: View {
      @EnvironmentObject var cookConversionViewModel: CookConversionViewModel
      @Binding var buttonRotation: Double

      var body: some View {
        Button(action: {
          withAnimation(.easeInOut) {
            buttonRotation += 180
          }

          cookConversionViewModel.reverseInputAndResultMeasures()
        }, label: {
          ZStack {
            Circle()
              .frame(width: 35, height: 35)
              .foregroundColor(.blackDarkSensitive)
            Image(systemName: "repeat")
              .resizable()
              .renderingMode(.template)
              .foregroundColor(.whiteDarkSensitive)
              .frame(width: 20, height: 20)
          }
        })
          .rotationEffect(.degrees(buttonRotation))
          .offset(x: 0, y: 25)
      }
    }

    private struct SettingsButton: View {
      @Binding var settingsScreenIsOpen: Bool

      var body: some View {
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
    }

  }

}
