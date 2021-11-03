//
//  ContentView.swift
//  CookConversion
//
//  Created by Gabriel on 11/1/21.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    ZStack {
      Color.lightGray
      VStack(spacing: 0) {
        TopSelectionSection()
        ConversionResponses()
        UserInputSection()
      }
    }
    .onTapGesture { UIApplication.shared.stopShowingKeyboard() }
    .ignoresSafeArea()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct TopSelectionSection: View {
  @ObservedObject private var keyboard = KeyboardResponder()
  @Environment(\.topSafeAreaSize) var topSafeAreaSize

  var body: some View {
    ZStack {
      ZStack {
        Rectangle()
          .foregroundColor(Color.skyBlue)
          .cornerRadius(Constants.bigRadius, corners: [.bottomLeft, .bottomRight])
      }
      VStack {
        HStack(alignment: .bottom, spacing: Constants.smallPadding) {
          TapDownButton(measurementType: .preciseMeasure)
          TapDownButton(measurementType: .easyMeasure)
        }
        .frame(height: Constants.bigButtonHeight)
        .padding(.top, topSafeAreaSize + Constants.standardPadding)
        .padding(Constants.standardPadding)
      }
      .frame(maxHeight: .infinity)
    }
    .ignoresSafeArea()
    .frame(maxWidth: .infinity)
    .frame(height: 120) // TODO: Change based on top safe area height
    .zIndex(1)
    // Need this negative padding otherwise this view will move up when keyboard opens
    .padding(.bottom, -keyboard.currentHeight)
  }
}

struct ConversionResponses: View {
  @EnvironmentObject var cookConversionViewModel: CookConversionViewModel
  @ObservedObject private var keyboard = KeyboardResponder()

  func getRandomID() -> String { UUID().uuidString }

  var body: some View {
    ZStack {
      ScrollView(showsIndicators: false) {
        VStack(spacing: Constants.smallPadding) {
          ForEach(cookConversionViewModel.previousConversions, id: \.self.id) { conversion in
            HStack {
              TextBalloon(horizontalAlignment: .leading,
                          topLabel: conversion.search.label,
                          text: conversion.search.text)
              TextBalloon(horizontalAlignment: .trailing,
                          topLabel: conversion.response.label,
                          text: conversion.response.text)
            }
          }
        }
        // The scroll view is reversed, the views need to be reversed again so they don't get upside down
        .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
        .padding(.vertical, Constants.standardPadding)
      }
      .padding(.horizontal, 10)
      // To reverse the scroll view
      .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.vertical, Constants.standardPadding)
  }
}

struct UserInputSection: View {
  @EnvironmentObject var cookConversionViewModel: CookConversionViewModel
  @ObservedObject private var keyboard = KeyboardResponder()

  var body: some View {
    ZStack {
      Rectangle()
        .foregroundColor(Color.white)
        .cornerRadius(Constants.bigRadius, corners: [.topLeft, .topRight])
      VStack {
        HStack {
          ZStack {
            RoundedRectangle(cornerRadius: Constants.standardRadius)
              .foregroundColor(Color.lightGray)
            ConversionTextField(textInput: $cookConversionViewModel.currentTypedNumber,
                                placeholderText: "25")
          }
          .scaledToFit()
          Text(cookConversionViewModel.currentSelectedPreciseMeasure.getNameAndAbbreviation().name)
            .font(.title2.weight(.heavy))
            .foregroundColor(.black)
        }
        .frame(height: Constants.bigButtonHeight)
        .padding(.bottom, Constants.smallPadding)
        Button(action: { cookConversionViewModel.convert() }, label: {
          ZStack {
            RoundedRectangle(cornerRadius: Constants.standardRadius)
              .foregroundColor(Color.skyBlue)
            Text("Convert")
              .foregroundColor(.white)
              .font(.title3.weight(.semibold))
          }
        })
        .frame(height: Constants.bigButtonHeight)
        .padding(.bottom, Constants.standardPadding)

        Spacer()
      }
      .padding(Constants.standardPadding)
    }
    .frame(height: 150)
    .frame(maxWidth: .infinity)
    .ignoresSafeArea()
    // So when the keyboard opens the view goes up accordingly
    .padding(.bottom, keyboard.currentHeight)
    .animation(.easeOut(duration: 0.16))
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
