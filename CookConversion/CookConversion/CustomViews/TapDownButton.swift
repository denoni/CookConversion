//
//  TapDownButton.swift
//  CookConversion
//
//  Created by Gabriel on 11/1/21.
//

import SwiftUI

struct TapDownButton: View {
  @EnvironmentObject var cookConversionViewModel: CookConversionViewModel
  @State var isShowingMenu = false
  let measurementType: CookConversionModel.MeasurementType

  var body: some View {
    Menu(content: { MenuItems(isShowingMenu: $isShowingMenu, measurementType: measurementType) },
         label: { TapButtonLayout(isShowingMenu: isShowingMenu, measurementType: measurementType) })
  }

  fileprivate struct TapButtonLayout: View {
    @EnvironmentObject var cookConversionViewModel: CookConversionViewModel
    @State var isShowingMenu: Bool
    var measurementType: CookConversionModel.MeasurementType

    var body: some View {
      ZStack {
        RoundedRectangle(cornerRadius: Constants.standardRadius, style: .continuous)
          .foregroundColor(.whiteDarkSensitive)
        HStack {
          Group {
            let currentMeasure = cookConversionViewModel.getCurrentSelectedMeasureFor(measurementType).getNameAndAbbreviation().name
            Text(currentMeasure)
              .foregroundColor(.blackDarkSensitive)
              .font(.system(size: 15))
              .fontWeight(.semibold)
              .minimumScaleFactor(0.7)
              .lineLimit(currentMeasure.contains(" ") ? 2 : 1) // If the measure name contains spaces, set limit to 2, else to 1
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
      }
    }
  }

  fileprivate struct MenuItems: View {
    @EnvironmentObject var cookConversionViewModel: CookConversionViewModel
    @Binding var isShowingMenu: Bool
    let measurementType: CookConversionModel.MeasurementType

    private func selectItemOfCurrentType(item: CookConversionModel.Measure) {
      switch measurementType {
      case .commonMeasure:
        cookConversionViewModel.currentSelectedCommonMeasure = item
      case .preciseMeasure:
        cookConversionViewModel.currentSelectedPreciseMeasure = item
      }
    }

    var body: some View {
      ForEach(cookConversionViewModel.getEnabledMeasures(for: measurementType), id: \.self.name) { measure in
        Group {
          let name = measure.name
          let abbreviated = measure.abbreviated != nil ? "- (\(measure.abbreviated!))" : ""

          Button(action: { selectItemOfCurrentType(item: measure) }, label: {
            Text("\(name) \(abbreviated)")
          })
        }
      }
      .onDisappear { isShowingMenu = false }
    }
  }
}
