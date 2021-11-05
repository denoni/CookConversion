//
//  UserInputSection.swift
//  CookConversion
//
//  Created by Gabriel on 11/5/21.
//

import SwiftUI

struct UserInputSection: View {
  @EnvironmentObject var cookConversionViewModel: CookConversionViewModel
  @ObservedObject private var keyboardResponder = KeyboardResponder()

  var body: some View {
    ZStack {
      Rectangle()
        .foregroundColor(Color.whiteDarkSensitive)
        .cornerRadius(Constants.bigRadius, corners: [.topLeft, .topRight])
      VStack {
        HStack {
          CustomStepper()
            .padding(.trailing, Constants.smallPadding)
          ZStack {
            RoundedRectangle(cornerRadius: Constants.standardRadius)
              .foregroundColor(Color.lightGray)
            ConversionTextField(textInput: $cookConversionViewModel.currentTypedNumber,
                                placeholderText: "25")
          }
          .scaledToFit()
          Text(cookConversionViewModel.currentSelectedPreciseMeasure.getNameAndAbbreviation().name)
            .font(.title2.weight(.heavy))
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .foregroundColor(.blackDarkSensitive)
            .padding(.leading, 5)
        }
        .frame(height: Constants.bigButtonHeight)
        .padding(.bottom, Constants.smallPadding)
        ConversionButton()
          .padding(.bottom, Constants.standardPadding)
        Spacer()
      }
      .padding(Constants.standardPadding)
    }
    .frame(height: 150)
    .frame(maxWidth: .infinity)
    .ignoresSafeArea()
    // So when the keyboard opens the view goes up accordingly
    .padding(.bottom, keyboardResponder.currentHeight)
    .animation(.easeOut(duration: 0.16))
    // If user taps in some view(that's not a tappable item), close keyboard and menus
    .onTapGesture { cookConversionViewModel.stopShowingKeyboardAndMenus() }
  }

  fileprivate struct CustomStepper: View {
    @EnvironmentObject var cookConversionViewModel: CookConversionViewModel

    var body: some View {
      HStack(spacing: 5) {
        Button(action: { cookConversionViewModel.decreaseCurrentTypedNumberByOne() }, label: {
          RoundedRectangle(cornerRadius: 10, style: .continuous)
            .frame(width: 40, height: 40)
            .foregroundColor(Color.lightGray)
            .overlay(Text("-").font(.title3).bold().foregroundColor(Color.blackDarkSensitive))
        })
        Button(action: { cookConversionViewModel.increaseCurrentTypedNumberByOne() }, label: {
          RoundedRectangle(cornerRadius: 10, style: .continuous)
            .frame(width: 40, height: 40)
            .foregroundColor(Color.lightGray)
            .overlay(Text("+").font(.title3).bold().foregroundColor(Color.blackDarkSensitive))
        })
      }
    }
  }

  fileprivate struct ConversionButton: View {
    @EnvironmentObject var cookConversionViewModel: CookConversionViewModel
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
      Button(action: { cookConversionViewModel.convert() }, label: {
        ZStack {
          RoundedRectangle(cornerRadius: Constants.standardRadius)
            .foregroundColor(cookConversionViewModel.buttonIsCurrentlyShowingErrorMessage ? .red : .skyBlue)
            .onChange(of: cookConversionViewModel.buttonIsCurrentlyShowingErrorMessage) { isShowingErrorMessage in
              if isShowingErrorMessage == true { simpleErrorHaptic() }
            }
          Text(cookConversionViewModel.convertButtonText)
            .foregroundColor(colorScheme == .light ? .whiteDarkSensitive : .blackDarkSensitive)
            .font(.title3.weight(.semibold))
            .lineLimit(2)
            .minimumScaleFactor(0.6)
            .padding(.vertical, Constants.smallPadding)
            .padding(.horizontal, Constants.standardPadding)
        }
      })
        .frame(height: Constants.bigButtonHeight)
    }

    private func simpleErrorHaptic() {
      let generator = UINotificationFeedbackGenerator()
      generator.notificationOccurred(.error)
    }
  }
}
