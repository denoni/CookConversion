//
//  CookConversionViewModel.swift
//  CookConversion
//
//  Created by Gabriel on 11/2/21.
//

import Foundation
import SwiftUI

class CookConversionViewModel: ObservableObject {
  private static let model = CookConversionModel()
  @Published var currentTypedNumber: String = ""
  @Published var currentSelectedPreciseMeasure: CookConversionModel.Measure = .preciseMeasure(.ounce)
  @Published var currentSelectedEasyMeasure: CookConversionModel.Measure = .easyMeasure(.tablespoon)
  
  // Create the list of conversions and add a sample conversion as the first element
  @Published var previousConversions: [ConversionItem] = [ConversionItem(search: (label:  "oz.",text: "10"),
                                                                         response: (label: "tbsp.", text: "20"))]
  
  // The button text is also used to show indications that the typed string is not valid
  // (e.g. is not a double or is bigger than the limit)
  @Published var convertButtonText = "Convert"
  @Published var buttonIsCurrentlyShowingErrorMessage = false

  @Published var isShowingPreciseMeasureMenu = false
  @Published var isShowingEasyMeasureMenu = false
  
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

    guard currentTypedNumberIsValid().booleanResponse != false else {
      handleInvalidCurrentTypedValue()
      return
    }
    stopShowingKeyboardAndMenus()
    
    let formattedCurrentTypedNumber = CookConversionViewModel.model.numberFormatter.number(from: currentTypedNumber)!.doubleValue
    
    let result = CookConversionViewModel.model.convert(formattedCurrentTypedNumber,
                                                       from: currentSelectedPreciseMeasure,
                                                       to: currentSelectedEasyMeasure)
    
    let formattedCurrentTypedNumberAsString = CookConversionViewModel.model.numberFormatter.string(from: NSNumber(value: formattedCurrentTypedNumber))!
    let formattedResultNumberAsString = CookConversionViewModel.model.numberFormatter.string(from: NSNumber(value: result)) ?? "0"
    
    
    previousConversions.append(ConversionItem(search: (label: currentSelectedPreciseMeasure.abbreviated ?? currentSelectedPreciseMeasure.name,
                                                       text: formattedCurrentTypedNumberAsString),
                                              response: (label: currentSelectedEasyMeasure.abbreviated ?? currentSelectedEasyMeasure.name,
                                                         text: formattedResultNumberAsString) ))
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

  func increaseCurrentTypedNumberByOne() {
    if currentTypedNumber.isEmpty { currentTypedNumber = "0" }
    guard currentTypedNumberIsValid().booleanResponse != false else {
      handleInvalidCurrentTypedValue()
      return
    }

    var currentTypedNumberAsDouble = CookConversionViewModel.model.numberFormatter.number(from: currentTypedNumber)!.doubleValue
    currentTypedNumberAsDouble += 1
    print(currentTypedNumberAsDouble)
    let newCurrentTypedNumberAsString = CookConversionViewModel.model.numberFormatter.string(from: NSNumber(value: currentTypedNumberAsDouble))!
    currentTypedNumber = newCurrentTypedNumberAsString
  }

  func decreaseCurrentTypedNumberByOne() {
    if currentTypedNumber.isEmpty { currentTypedNumber = "0" }
    guard currentTypedNumberIsValid().booleanResponse != false else {
      handleInvalidCurrentTypedValue()
      return
    }
    var currentTypedNumberAsDouble = CookConversionViewModel.model.numberFormatter.number(from: currentTypedNumber)!.doubleValue
    currentTypedNumberAsDouble -= 1
    let newCurrentTypedNumberAsString = CookConversionViewModel.model.numberFormatter.string(from: NSNumber(value: currentTypedNumberAsDouble))!
    currentTypedNumber = newCurrentTypedNumberAsString
  }

  func stopShowingKeyboardAndMenus() {
    UIApplication.shared.stopShowingKeyboard()
    isShowingPreciseMeasureMenu = false
    isShowingEasyMeasureMenu = false
  }
  
  func getCurrentSelectedMeasureFor(_ measurementType: CookConversionModel.MeasurementType) -> CookConversionModel.Measure {
    switch measurementType {
    case .preciseMeasure:
      return currentSelectedPreciseMeasure
    case .easyMeasure:
      return currentSelectedEasyMeasure
    }
  }

  private func handleInvalidCurrentTypedValue() {
    buttonIsCurrentlyShowingErrorMessage = true

    // Change the button text to a message saying why the number is invalid
    convertButtonText = currentTypedNumberIsValid().description
    // After 1 sec, start to show the standard button text again (e.g. "Convert")
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.buttonIsCurrentlyShowingErrorMessage = false
      self.convertButtonText = "Convert"
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
