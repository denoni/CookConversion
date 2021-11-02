//
//  TapDownButton.swift
//  CookConversion
//
//  Created by Gabriel on 11/1/21.
//

import SwiftUI

struct TapDownButton: View {
  @EnvironmentObject var cookConversionViewModel: CookConversionViewModel
  var measurementType: CookConversionModel.MeasurementType
  @State private var shouldShowMenu = false

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
          Text(cookConversionViewModel.getCurrentSelectedMeasureFor(measurementType))
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
          PopOverMenu(selectedItemText: measurementType == .preciseMeasure
                      ? $cookConversionViewModel.currentSelectedPreciseMeasure
                      : $cookConversionViewModel.currentSelectedEasyMeasure,
                      measurementType: measurementType)
        }
      }, alignment: .topLeading
    )
  }
}

struct PopOverMenu: View {
  @EnvironmentObject var cookConversionViewModel: CookConversionViewModel
  @Binding var selectedItemText: String
  var measurementType: CookConversionModel.MeasurementType

  var body: some View {
      ZStack {
        RoundedRectangle(cornerRadius: Constants.standardRadius, style: .continuous)
          .foregroundColor(.white)
        ScrollView {
          VStack {
            ForEach(CookConversionViewModel.getMeasuresFor(measurementType), id: \.self.name) { measure in
              Button(action: { selectedItemText = measure.name }, label: {
                VStack {
                  Text(measure.name)
                  if let abbreviatedName = measure.abbreviated {
                    Text("(\(abbreviatedName))")
                      .font(.footnote.weight(.bold))
                  }
                }
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


