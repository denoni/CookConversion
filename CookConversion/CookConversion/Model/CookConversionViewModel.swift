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
                                                                         response: (label: "Tablespoon", text: "6.7 tbsp."))]

  // The button text is also used to show indications that the typed string is not valid
  // (e.g. is not a double or is bigger than the limit)
  @Published var convertButtonText = "Convert"
  @Published var buttonIsCurrentlyShowingErrorMessage = false

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

    guard currentTypedNumberIsValid().booleanResponse == true else {
      buttonIsCurrentlyShowingErrorMessage = true

      // Change the button text to a message saying why the number is invalid
      convertButtonText = currentTypedNumberIsValid().description
      // After 1 sec, start to show the standard button text again (e.g. "Convert")
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        self.buttonIsCurrentlyShowingErrorMessage = false
        self.convertButtonText = "Convert"
      }
      return
    }

    let formattedCurrentTypedNumber = CookConversionViewModel.model.numberFormatter.number(from: currentTypedNumber)!.doubleValue

    let result = CookConversionViewModel.model.convert(formattedCurrentTypedNumber,
                                                       from: currentSelectedPreciseMeasure,
                                                       to: currentSelectedEasyMeasure)

    let formattedResultNumber = CookConversionViewModel.model.numberFormatter.string(from: NSNumber(value: result)) ?? "0"

    let searchStringFormatted = "\(formattedCurrentTypedNumber) \(currentSelectedPreciseMeasure.abbreviated ?? "")"
    let resultStringFormatted = "\(formattedResultNumber) \(currentSelectedEasyMeasure.abbreviated ?? "")"

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

  private func currentTypedNumberIsValid() -> (booleanResponse: Bool, description: String) {
    guard let typedNumberAsDouble = CookConversionViewModel.model.numberFormatter.number(from: currentTypedNumber)?.doubleValue else {
      return (booleanResponse: false, description: "Typed value is not a number")
    }
    guard typedNumberAsDouble <= 5000 else {
      return (booleanResponse: false, description: "Value can't be higher than 5000")
    }
    return (booleanResponse: true, description: "Success")
  }

}
