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

  @Published var previousConversions: [ConversionItem] = [ConversionItem(search: (label: "Grams", text: "120 g"),
                                                                         response: (label: "Tablespoon", text: "10 tbsp."))]

  struct ConversionItem: Identifiable {
    var search: (label: String, text: String)
    var response: (label: String, text: String)
    let id = UUID()
  }

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
    let searchStringFormatted = "\(currentTypedNumber) \(currentSelectedPreciseMeasure.abbreviated ?? "")"
    let resultStringFormatted = "\(String(format: "%.2f", result)) \(currentSelectedEasyMeasure.abbreviated ?? "")"

    previousConversions.append(ConversionItem(search: (label: currentSelectedPreciseMeasure.name, text: searchStringFormatted),
                                              response: (label: currentSelectedEasyMeasure.name, text: resultStringFormatted)))
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
