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
      Color.green
      VStack {
        Spacer()
        HStack(alignment: .bottom, spacing: 15) {
          TapDownButton(text: "Grams")
          TapDownButton(text: "Tablespoon")
        }
        .frame(height: 60)
        .padding(.bottom, 30)
      }
      .frame(maxHeight: .infinity)
      .padding(30)
    }
    .frame(height: 200)
    .frame(maxWidth: .infinity)
    .padding(.bottom, -30)
  }
}

struct ConversionsResponses: View {
  var body: some View {
    ZStack {
      Color(UIColor.systemGray5)
      VStack(spacing: 15) {
        Spacer()
        TextBalloon(horizontalAlignment: .trailing, topLabel: "Grams", text: "120g")
        TextBalloon(horizontalAlignment: .leading, topLabel: "Tablespoon", text: "5tbsp")
      }
      .padding(.horizontal, 10)
      .padding(.vertical, 30)
      .padding(.bottom, 30)
    }
    .cornerRadius(19, corners: [.topLeft, .topRight])
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.bottom, -30)
  }
}

struct UserInputSection: View {
  var body: some View {
    ZStack {
      Color.white
      VStack {
        Text("Type the measure to convert...")
          .font(.title2)
          .fontWeight(.bold)
          .opacity(0.35)
      }
    }
    .cornerRadius(19, corners: [.topLeft, .topRight])
    .frame(height: 300)
    .frame(maxWidth: .infinity)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
