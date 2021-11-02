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
        RoundedRectangle(cornerRadius: 19, style: .continuous)
          .foregroundColor(.white)
        HStack {
          Text(selectedItemText)
            .foregroundColor(.black)
            .fontWeight(.semibold)
            .padding(.leading, 20)
            .padding(.trailing, 10)
          Spacer()
          Rectangle()
            .foregroundColor(.black.opacity(0.2))
            .frame(width: 2)
            .frame(maxHeight: .infinity)
          Image(systemName: shouldShowMenu ? "chevron.up" : "chevron.down")
            .foregroundColor(.black)
            .scaledToFit()
            .padding(.trailing, 10)
        }
      }
    })
    .overlay(
      VStack {
        if self.shouldShowMenu {
          Spacer(minLength: 60 + 10)
          PopOverMenu(selectedItemText: $selectedItemText, measurementType: measurementType)
        }
      }, alignment: .topLeading
    )
  }
}

struct PopOverMenu: View {
  @Binding var selectedItemText: String
  var measurementType: MeasurementType

  private let preciseMeasures = ["Ounce (oz.)", "Gallon (gal.)", "Milligrams (mg)", "Grams (g)", "Kilograms (kg)", "Milliliters (mL)", "Liter (L)"]
  private let easyMeasures = ["Teaspoon (tsp.)", "Tablespoon (tbsp.)", "Cup", "Pinch", "Wineglass", "Teacup"]

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
        RoundedRectangle(cornerRadius: 19, style: .continuous)
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
      .padding(.horizontal, 30)
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
