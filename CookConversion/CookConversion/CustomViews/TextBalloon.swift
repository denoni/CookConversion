//
//  TextBalloon.swift
//  CookConversion
//
//  Created by Gabriel on 11/1/21.
//

import SwiftUI

struct TextBalloon: View {
  var horizontalAlignment: HorizontalAlignment
  var topLabel: String
  var text: String

  private let balloonOpacity = 0.9
  private let leadingBalloonColor = Color.whiteDarkSensitive
  private let trailingBallonColor = Color.lightSkyBlue

  var body: some View {
    HStack {

      if horizontalAlignment == .leading {
        HStack(spacing: 0) {
          BalloonAdjustedArc(horizontalAlignment: .leading, opacity: balloonOpacity)
          ZStack {
            RoundedRectangle(cornerRadius: Constants.standardRadius, style: .continuous)
              .opacity(balloonOpacity)
            BalloonText(topLabel: topLabel, text: text, alignment: .leading)
          }
          Spacer()
        }
        .foregroundColor(leadingBalloonColor)
      }

      if horizontalAlignment == .trailing {
        HStack(spacing: 0) {
          Spacer()
          ZStack {
            RoundedRectangle(cornerRadius: Constants.standardRadius, style: .continuous)
              .opacity(balloonOpacity)
            BalloonText(topLabel: topLabel, text: text, alignment: .trailing)
          }
          BalloonAdjustedArc(horizontalAlignment: .trailing, opacity: balloonOpacity)
        }
        .foregroundColor(trailingBallonColor)
      }

    }
    .frame(maxWidth: .infinity, maxHeight: 120)
  }

  private struct BalloonText: View {
    var topLabel: String
    var text: String
    var alignment: HorizontalAlignment

    var body: some View {
      HStack {
        if alignment == .trailing { Spacer() }

        VStack(alignment: alignment) {
          Text(topLabel)
            .fontWeight(.semibold)
          Text(text)
            .font(.title)
            .fontWeight(.black)
            .minimumScaleFactor(0.5)
            .lineLimit(2)
            .multilineTextAlignment(alignment == .leading ? .leading : .trailing)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, Constants.smallPadding)
        .padding(.horizontal, Constants.standardPadding)

        if alignment == .leading { Spacer() }
      }
      .foregroundColor(.blackDarkSensitive)
      .frame(maxWidth: .infinity)
    }
  }

}

private struct BalloonAdjustedArc: View {
  var horizontalAlignment: HorizontalAlignment
  var opacity: Double

  private let arcHeight: CGFloat = 15
  private let arcWidth: CGFloat = 30

  var body: some View {
    VStack {
      Spacer()
      Arc(height: arcHeight, length: arcWidth)
        .rotationEffect(horizontalAlignment == .leading ? .zero : .degrees(180))
        .frame(width: arcHeight, height: arcWidth)
        .padding(.bottom, Constants.standardRadius)
        .opacity(opacity)
    }
  }
}

fileprivate struct Arc: Shape {
  var height: CGFloat
  var length: CGFloat
  var startY: CGFloat = 0

  func path(in rect: CGRect) -> Path {
    var path = Path()
    let midPoint: CGFloat = (startY + length) / 2
    let apex1: CGFloat = (startY + midPoint) / 2
    let apex2: CGFloat = (midPoint + length) / 2

    path.move(to: CGPoint(x: height, y: startY))
    path.addCurve(to: CGPoint(x: 0, y: midPoint),
                  control1: CGPoint(x: height, y: apex1),
                  control2: CGPoint(x: 0, y: apex1))
    path.addCurve(to: CGPoint(x: height, y: length),
                  control1: CGPoint(x: 0, y: apex2),
                  control2: CGPoint(x: height, y: apex2))

    return path
  }
}
