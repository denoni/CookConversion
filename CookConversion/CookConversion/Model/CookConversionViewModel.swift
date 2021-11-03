//
//  CookConversionViewModel.swift
//  CookConversion
//
//  Created by Gabriel on 11/2/21.
//

import Foundation

class CookConversionViewModel: ObservableObject {
  private static let model = CookConversionModel()
  @Published var currentTypedNumber: String = ""
  @Published var currentSelectedPreciseMeasure: CookConversionModel.Measure = .preciseMeasure(.ounce)
  @Published var currentSelectedEasyMeasure: CookConversionModel.Measure = .easyMeasure(.tablespoon)


  // MARK: - Intent(s)
  static func getPreciseMeasures() -> [CookConversionModel.Measure] {
    return model.getPreciseMeasures()
  }

  static func getEasyMeasures() -> [CookConversionModel.Measure] {
    return model.getEasyMeasures()
  }

  func convert() {
    let result = CookConversionViewModel.model.convert(Double(currentTypedNumber) ?? 0,
                                                       from: currentSelectedPreciseMeasure,
                                                       to: currentSelectedEasyMeasure)
    print(result)
  }

  // MARK: - Auxiliary Functions
  static func getMeasuresFor(_ measurementType: CookConversionModel.MeasurementType) -> [CookConversionModel.Measure] {
    switch measurementType {
    case .preciseMeasure:
      return getPreciseMeasures()
    case .easyMeasure:
      return getEasyMeasures()
    }
  }

  static func getOnlyFirstMeasuresFor(_ measurementType: CookConversionModel.MeasurementType) -> CookConversionModel.Measure {
    return getMeasuresFor(measurementType).first!
  }

  func getCurrentSelectedMeasureFor(_ measurementType: CookConversionModel.MeasurementType) -> CookConversionModel.Measure {
    switch measurementType {
    case .preciseMeasure:
      return currentSelectedPreciseMeasure
    case .easyMeasure:
      return currentSelectedEasyMeasure
    }
  }

}
