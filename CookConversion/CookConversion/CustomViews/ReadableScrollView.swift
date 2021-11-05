//
//  ReadableScrollView.swift
//  CookConversion
//
//  Created by Gabriel on 11/3/21.
//

import SwiftUI

struct ReadableScrollView<Content: View>: View {
  @Binding var currentPosition: CGFloat
  var reversedScrolling = false
  @ViewBuilder var content: Content

  var body: some View {
    ScrollView(showsIndicators: false) {
      Group {
        content
        // If the scroll view is reversed, the views need to be reversed again so they don't get upside down
          .rotationEffect(Angle(degrees: reversedScrolling ? 180 : 0))
      }
      .background(GeometryReader {
        Color.clear.preference(key: ViewOffsetKey.self,
                               value: -$0.frame(in: .named("scroll")).origin.y)
      })
      .onPreferenceChange(ViewOffsetKey.self) { currentPosition = $0 }
    }
    .coordinateSpace(name: "scroll")
    // To reverse the scroll view
    .rotationEffect(Angle(degrees: reversedScrolling ? 180 : 0))
  }
}

struct ViewOffsetKey: PreferenceKey {
  typealias Value = CGFloat
  static var defaultValue = CGFloat.zero
  static func reduce(value: inout Value, nextValue: () -> Value) {
    value += nextValue()
  }
}
