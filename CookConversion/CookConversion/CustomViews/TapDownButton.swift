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
  @Binding var isShowingMenu: Bool

  var body: some View {
    Button(action: {
      withAnimation(.interactiveSpring()) {
        isShowingMenu.toggle()
      }
    }, label: {
      ZStack {
        RoundedRectangle(cornerRadius: Constants.standardRadius, style: .continuous)
          .foregroundColor(.whiteDarkSensitive)
        HStack {
          Text(cookConversionViewModel.getCurrentSelectedMeasureFor(measurementType).getNameAndAbbreviation().name)
            .foregroundColor(.blackDarkSensitive)
            .font(.system(size: 15))
            .fontWeight(.semibold)
            .padding(.leading, 20)
            .padding(.trailing, 5)
          Spacer()
          Rectangle()
            .foregroundColor(.blackDarkSensitive.opacity(0.2))
            .frame(width: 2)
            .frame(maxHeight: .infinity)
          Image(systemName: isShowingMenu ? "chevron.up" : "chevron.down")
            .foregroundColor(.blackDarkSensitive)
            .scaledToFit()
            .padding(.trailing, Constants.smallPadding)
        }
      }
    })
    .overlay(
      VStack {
        if self.isShowingMenu {
          Spacer(minLength: Constants.bigButtonHeight + Constants.smallPadding)
          PopOverMenu(selectedItem: measurementType == .preciseMeasure
                      ? $cookConversionViewModel.currentSelectedPreciseMeasure
                      : $cookConversionViewModel.currentSelectedEasyMeasure,
                      isShowingMenu: $isShowingMenu,
                      measurementType: measurementType)
        }
      }, alignment: .topLeading
    )
  }
}

struct PopOverMenu: View {
  @EnvironmentObject var cookConversionViewModel: CookConversionViewModel
  @Binding var selectedItem: CookConversionModel.Measure
  @Binding var isShowingMenu: Bool
  var measurementType: CookConversionModel.MeasurementType

  var body: some View {
      ZStack {
        RoundedRectangle(cornerRadius: Constants.standardRadius, style: .continuous)
          .foregroundColor(.whiteDarkSensitive)
        ScrollView {
          VStack {
            ForEach(CookConversionViewModel.getMeasuresFor(measurementType), id: \.self.name) { measure in
              Button(action: {
                selectedItem = measure
                isShowingMenu = false
              }, label: {
                VStack {
                  Text(measure.name)
                  if let abbreviatedName = measure.abbreviated {
                    Text("(\(abbreviatedName))")
                      .font(.footnote.weight(.bold))
                  }
                }
                .foregroundColor(.blackDarkSensitive)
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


