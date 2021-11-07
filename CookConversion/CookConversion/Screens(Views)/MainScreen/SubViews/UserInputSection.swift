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

  var currentPreciseMeasure: String {
    cookConversionViewModel.currentSelectedPreciseMeasure.getNameAndAbbreviation().name
  }

  var currentCommonMeasure: String {
    cookConversionViewModel.currentSelectedCommonMeasure.getNameAndAbbreviation().name
  }

  var accessibilityLabelOfCurrentValueTextField: Text {
    if cookConversionViewModel.currentTypedValue == "" {
      return Text("Current value is empty")
    } else {
      return Text("Current value is \(cookConversionViewModel.currentTypedValue + currentPreciseMeasure)")
    }
  }

  var accessibilityLabelOfConvertButton: Text {
    if cookConversionViewModel.currentTypedValue == "" {
      return Text("Convert")
    } else {
      return Text("Tap to convert \(cookConversionViewModel.currentTypedValue) \(currentPreciseMeasure) to \(currentCommonMeasure)")
    }
  }

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
                .accessibilityElement(children: .ignore)
              ConversionTextField(textInput: $cookConversionViewModel.currentTypedValue,
                                  placeholderText: "25")
            }
            .scaledToFit()
            .accessibilityHint("Tap to write a new input value to convert.")
            .accessibility(addTraits: .isSearchField)
            .accessibilityElement(children: .combine)
            .accessibility(label: accessibilityLabelOfCurrentValueTextField)
            .accessibility(sortPriority: 3)

          Text(cookConversionViewModel.getCurrentSelectedOutputMeasure().name)
              .font(.title2.weight(.heavy))
              .lineLimit(1)
              .minimumScaleFactor(0.5)
              .foregroundColor(.blackDarkSensitive)
              .padding(.leading, 5)
              .accessibilityElement(children: .ignore)
        }
        .frame(height: Constants.bigButtonHeight)
        .padding(.bottom, Constants.smallPadding)
        ConversionButton()
          .padding(.bottom, Constants.standardPadding)
          .accessibility(label: accessibilityLabelOfConvertButton)
          .accessibility(sortPriority: 3)
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
    .onTapGesture { UIApplication.shared.stopShowingKeyboard() }
  }

  fileprivate struct CustomStepper: View {
    @EnvironmentObject var cookConversionViewModel: CookConversionViewModel

    var body: some View {
      HStack(spacing: 5) {
        Button(action: { cookConversionViewModel.decreaseCurrentTypedValueByOne() }, label: {
          RoundedRectangle(cornerRadius: 10, style: .continuous)
            .frame(width: 40, height: 40)
            .foregroundColor(Color.lightGray)
            .overlay(Text("-").font(.title3).bold().foregroundColor(Color.blackDarkSensitive))
        })
          .accessibilityLabel("Decrease")
          .accessibilityHint("Tap to increase current input value by one")
          .accessibility(sortPriority: 1)
        Button(action: { cookConversionViewModel.increaseCurrentTypedValueByOne() }, label: {
          RoundedRectangle(cornerRadius: 10, style: .continuous)
            .frame(width: 40, height: 40)
            .foregroundColor(Color.lightGray)
            .overlay(Text("+").font(.title3).bold().foregroundColor(Color.blackDarkSensitive))
        })
          .accessibilityLabel("Increase")
          .accessibilityHint("Tap to increase current input value by one")
          .accessibility(sortPriority: 1)
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
