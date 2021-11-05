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
      ReadableScrollView(currentPosition: $currentScrollViewPosition) {
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
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.6)))
          }
        }
        // TODO: Do this better
        // The scroll view is reversed, the views need to be reversed again so they don't get upside down
        .rotationEffect(Angle(degrees: 180))
        .padding(.vertical, Constants.standardPadding)
      }
      .padding(.horizontal, 10)
      // To reverse the scroll view
      .rotationEffect(Angle(degrees: 180))
      .onChange(of: currentScrollViewPosition, perform: { _ in
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
