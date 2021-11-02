//
//  ContentView.swift
//  CookConversion
//
//  Created by Gabriel on 11/1/21.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack(spacing: 0) {
      TopSelectionSection()
      ConversionsResponses()
      UserInputSection()
    }
    .ignoresSafeArea()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct TopSelectionSection: View {
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 19)
        .foregroundColor(Color(red: 26/255, green: 185/255, blue: 235/255))
      VStack {
        Spacer()
        HStack(alignment: .bottom, spacing: 15) {
          TapDownButton(measurementType: .preciseMeasure)
          TapDownButton(measurementType: .easyMeasure)
        }
        .frame(height: 60)
        .padding(.bottom, 10)
        .padding(.top, 60)
      }
      .frame(maxHeight: .infinity)
      .padding(30)
    }
    .ignoresSafeArea()
    .frame(maxWidth: .infinity)
    .padding(.bottom, -30)
    .zIndex(1)
    .scaledToFit()
  }
}

struct ConversionsResponses: View {
  let lightGrey = Color(red: 229/255, green: 229/255, blue: 229/255)
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 19)
        .foregroundColor(lightGrey)
      VStack(spacing: 15) {
        Spacer()
        TextBalloon(horizontalAlignment: .trailing, topLabel: "Grams", text: "120g")
        TextBalloon(horizontalAlignment: .leading, topLabel: "Tablespoon", text: "5tbsp")
      }
      .padding(.horizontal, 10)
      .padding(.vertical, 30)
      .padding(.bottom, 30)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.bottom, -30)
  }
}

struct UserInputSection: View {
  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 19)
        .foregroundColor(.white)
      VStack {
        Text("Type the measure to convert...")
          .font(.title2)
          .fontWeight(.bold)
          .opacity(0.35)
      }
    }
    .frame(height: 200)
    .frame(maxWidth: .infinity)
    .ignoresSafeArea()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
