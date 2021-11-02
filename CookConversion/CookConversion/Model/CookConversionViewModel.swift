//
//  CookConversionViewModel.swift
//  CookConversion
//
//  Created by Gabriel on 11/2/21.
//

import Foundation

class CookConversionViewModel: ObservableObject {
  static let model = CookConversionModel()
  @Published var currentSelectedPreciseMeasure: String = getOnlyFirstMeasuresFor(.preciseMeasure).name
  @Published var currentSelectedEasyMeasure: String = getOnlyFirstMeasuresFor(.easyMeasure).name


  // MARK: - Intent(s)
  static func getPreciseMeasures() -> [(name: String, abbreviated: String)] {
    return model.getPreciseMeasures()
  }

  static func getEasyMeasures() -> [(name: String, abbreviated: String?)] {
    return model.getEasyMeasures()
  }



  // MARK: - Auxiliary Functions
  static func getMeasuresFor(_ measurementType: CookConversionModel.MeasurementType) -> [(name: String, abbreviated: String?)] {
    switch measurementType {
    case .preciseMeasure:
      return getPreciseMeasures()
    case .easyMeasure:
      return getEasyMeasures()
    }
  }

  static func getOnlyFirstMeasuresFor(_ measurementType: CookConversionModel.MeasurementType) -> (name: String, abbreviated: String?) {
    return getMeasuresFor(measurementType).first!
  }

  func getCurrentSelectedMeasureFor(_ measurementType: CookConversionModel.MeasurementType) -> String {
    switch measurementType {
    case .preciseMeasure:
      return currentSelectedPreciseMeasure
    case .easyMeasure:
      return currentSelectedEasyMeasure
    }
  }

}
