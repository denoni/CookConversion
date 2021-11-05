//
//  ConversionResponses.swift
//  CookConversion
//
//  Created by Gabriel on 11/5/21.
//

import SwiftUI

struct ConversionResponses: View {
  @EnvironmentObject var cookConversionViewModel: CookConversionViewModel
  @ObservedObject private var keyboard = KeyboardResponder()
  @State var currentScrollViewPosition: CGFloat = 0
  func getRandomID() -> String { UUID().uuidString }

  var body: some View {
    ZStack {
      ReadableScrollView(currentPosition: $currentScrollViewPosition, reversedScrolling: true) {
        VStack(spacing: Constants.smallPadding) {
          ForEach(cookConversionViewModel.previousConversions, id: \.self.id) { conversion in
            HStack {
              TextBalloon(horizontalAlignment: .leading,
                          topLabel: conversion.search.abbreviated,
                          text: conversion.search.value)
              TextBalloon(horizontalAlignment: .trailing,
                          topLabel: conversion.response.abbreviated,
                          text: conversion.response.value)
            }
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.6)))
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Conversion: \(conversion.search.value) \(conversion.search.measure) is equal to \(conversion.response.value) \(conversion.response.measure)")
            .accessibility(sortPriority: 2)
          }
        }
        .padding(.vertical, Constants.standardPadding)
      }
      .padding(.horizontal, 10)
      .onChange(of: currentScrollViewPosition, perform: { _ in
        print(currentScrollViewPosition)
        // If user scrolls, automatically close keyboard and menus
        cookConversionViewModel.stopShowingKeyboardAndMenus()
      })

      SmallFadingOnScrollViewVerticalBorders()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.top, -Constants.smallPadding)
    .padding(.vertical, Constants.standardPadding)
    // If user taps in some view(that's not a tappable item), close keyboard and menus
    .onTapGesture { cookConversionViewModel.stopShowingKeyboardAndMenus() }
  }

  fileprivate struct SmallFadingOnScrollViewVerticalBorders: View {
    var body: some View {
      // Small linear gradient in the top and bottom of the scroll view for a better looking when user scrolls.
      VStack {
        LinearGradient(colors: [.lightGray, .lightGray.opacity(0)], startPoint: .top, endPoint: .bottom)
          .frame(height: 15)
        Spacer()
        LinearGradient(colors: [.lightGray, .lightGray.opacity(0)], startPoint: .bottom, endPoint: .top)
          .frame(height: 15)
      }
    }
  }
}
