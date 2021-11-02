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
    .ignoresSafeArea()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct TopSelectionSection: View {
  @ObservedObject private var keyboard = KeyboardResponder()

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
        .padding(.top, 60) // TODO: Change based on top safe area height
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
  var body: some View {
    ZStack {
      ScrollView(showsIndicators: false) {
        VStack(spacing: Constants.smallPadding) {
          TextBalloon(horizontalAlignment: .trailing, topLabel: "Grams", text: "120g")
          TextBalloon(horizontalAlignment: .leading, topLabel: "Tablespoon", text: "5tbsp")
        }
        // The scroll view is reversed, the views need to be reversed again so they don't get upside down
        .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
        .padding(.vertical, Constants.standardPadding)
      }
      .padding(.horizontal, 10)
      // To reverse the scroll view
      .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
      .padding(.top, -40)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.top, Constants.standardPadding)
  }
}

struct UserInputSection: View {
  @State private var textInput: String = ""
  @ObservedObject private var keyboard = KeyboardResponder()

  var body: some View {
    ZStack {
      Rectangle()
        .foregroundColor(Color.white)
        .cornerRadius(Constants.bigRadius, corners: [.topLeft, .topRight])
      VStack {
        ConversionTextField(textInput: $textInput, placeholderText: "Type the measure here...")
        Spacer()
      }
      // So when the keyboard opens the view goes up accordingly
      .padding(Constants.standardPadding)
    }
    .frame(height: 120)
    .frame(maxWidth: .infinity)
    .ignoresSafeArea()
    .padding(.bottom, keyboard.currentHeight)
    .animation(.easeInOut(duration: 0.16))
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
