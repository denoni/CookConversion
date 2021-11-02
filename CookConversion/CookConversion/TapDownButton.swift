//
//  TapDownButton.swift
//  CookConversion
//
//  Created by Gabriel on 11/1/21.
//

import SwiftUI

struct TapDownButton: View {
  var measurementType: MeasurementType

  @State private var shouldShowMenu = false
  @State private var selectedItemText = "Ounce (oz.)"

  var body: some View {
    Button(action: {
      withAnimation(.interactiveSpring()) {
        shouldShowMenu.toggle()
      }
    }, label: {
      ZStack {
        RoundedRectangle(cornerRadius: Constants.standardRadius, style: .continuous)
          .foregroundColor(.white)
        HStack {
          Text(selectedItemText)
            .foregroundColor(.black)
            .fontWeight(.semibold)
            .padding(.leading, 20)
            .padding(.trailing, Constants.smallPadding)
          Spacer()
          Rectangle()
            .foregroundColor(.black.opacity(0.2))
            .frame(width: 2)
            .frame(maxHeight: .infinity)
          Image(systemName: shouldShowMenu ? "chevron.up" : "chevron.down")
            .foregroundColor(.black)
            .scaledToFit()
            .padding(.trailing, Constants.smallPadding)
        }
      }
    })
    .overlay(
      VStack {
        if self.shouldShowMenu {
          Spacer(minLength: Constants.bigButtonHeight + Constants.smallPadding)
          PopOverMenu(selectedItemText: $selectedItemText, measurementType: measurementType)
        }
      }, alignment: .topLeading
    )
  }
}

struct PopOverMenu: View {
  @Binding var selectedItemText: String
  var measurementType: MeasurementType

  private let preciseMeasures = ["Ounces (oz.)", "Gallons (gal.)", "Milligrams (mg)", "Grams (g)", "Kilograms (kg)", "Milliliters (mL)", "Liters (L)"]
  private let easyMeasures = ["Teaspoons (tsp.)", "Tablespoons (tbsp.)", "Cups", "Pinches", "Wineglasses", "Teacups"]

  private var measures: [String] {
    switch measurementType {
    case .preciseMeasure:
      return preciseMeasures
    case .easyMeasure:
      return easyMeasures
    }
  }

  var body: some View {
      ZStack {
        RoundedRectangle(cornerRadius: Constants.standardRadius, style: .continuous)
          .foregroundColor(.white)
        ScrollView {
          VStack {
            ForEach(measures, id: \.self) { measure in
              Button(action: { selectedItemText = measure }, label: {
                Text(measure)
                  .foregroundColor(.black)
                  .padding(.top, 5)
              })
              Divider()
            }
          }
          .padding()
        }
      }
      .padding(.horizontal, Constants.standardPadding)
      .shadow(radius: 25)
      .frame(width: 200)
      .frame(height: 250)
      .scaledToFit()
      .ignoresSafeArea()
      .zIndex(1)
    }
}

enum MeasurementType {
  case preciseMeasure
  case easyMeasure
}
