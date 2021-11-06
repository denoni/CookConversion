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
  @Published var currentSelectedPreciseMeasure: CookConversionModel.Measure = .preciseMeasure(preciseMeasure: .milliliter)
  @Published var currentSelectedCommonMeasure: CookConversionModel.Measure = .commonMeasure(commonMeasure: .tablespoon)

  // User can disable a measure so it won't appear in the list anymore. This dictionary controls what is active and what is not.
  @Published var measuresEnabledStatus = [CookConversionModel.Measure: Bool]() {
    didSet {
      if let encodedMeasuresEnabledStatus = try? JSONEncoder().encode(measuresEnabledStatus) {
        UserDefaults.standard.set(encodedMeasuresEnabledStatus, forKey: "measures-enabled-status")
      }
    }
  }
  
  // Create the list of conversions and add a sample conversion as the first element
  @Published var previousConversions: [ConversionItem] = [ConversionItem(search: (measure: LocalizedStringKey("ounces").stringValue(),
                                                                                  abbreviated:  LocalizedStringKey("ounces-abbreviated").stringValue(),
                                                                                  value: "10"),
                                                                         response: (measure: LocalizedStringKey("tablespoons").stringValue(),
                                                                                    abbreviated: LocalizedStringKey("tablespoons-abbreviated").stringValue(),
                                                                                    value: "20"))]
  
  // The button text is also used to show indications that the typed string is not valid
  // (e.g. is not a double or is bigger than the limit)
  @Published var convertButtonText: String = LocalizedStringKey("convert").stringValue()
  @Published var buttonIsCurrentlyShowingErrorMessage = false

  @Published var isShowingPreciseMeasureMenu = false
  @Published var isShowingCommonMeasureMenu = false
  @Published var isShowingOnboardingScreen = true

  struct ConversionItem: Identifiable {
    var search: (measure: String, abbreviated: String, value: String)
    var response: (measure: String, abbreviated: String, value: String)
    let id = UUID()
  }

  init() {
    let encodedMeasuresEnabledStatus = UserDefaults.standard.object(forKey: "measures-enabled-status") as? Data

    if encodedMeasuresEnabledStatus == nil {
      for preciseMeasure in CookConversionViewModel.getPreciseMeasures() {
        measuresEnabledStatus[preciseMeasure] = true
      }
      for commonMeasure in CookConversionViewModel.getCommonMeasures() {
        measuresEnabledStatus[commonMeasure] = true
      }
    } else {
      let measuresEnabledStatusInUserDefaults = try? JSONDecoder().decode([CookConversionModel.Measure: Bool].self, from: encodedMeasuresEnabledStatus!)
      measuresEnabledStatus = measuresEnabledStatusInUserDefaults!
    }

    currentSelectedCommonMeasure = getOnlyFirstEnabledMeasure(for: .commonMeasure)
    currentSelectedPreciseMeasure = getOnlyFirstEnabledMeasure(for: .preciseMeasure)
  }

  // MARK: - Intent(s)
  static func getPreciseMeasures() -> [CookConversionModel.Measure] {
    return model.getPreciseMeasures()
  }
  
  static func getCommonMeasures() -> [CookConversionModel.Measure] {
    return model.getCommonMeasures()
  }
  
  func convert() {

    guard currentTypedNumberIsValid().booleanResponse != false else {
      handleInvalidCurrentTypedValue()
      Accessibility.postConversionFailedNotification(errorMessage: convertButtonText)
      return
    }
    stopShowingKeyboardAndMenus()
    
    let formattedCurrentTypedNumber = CookConversionViewModel.model.numberFormatter.number(from: currentTypedNumber)!.doubleValue
    
    let result = CookConversionViewModel.model.convert(formattedCurrentTypedNumber,
                                                       from: currentSelectedPreciseMeasure,
                                                       to: currentSelectedCommonMeasure)
    
    let formattedCurrentTypedNumberAsString = CookConversionViewModel.model.numberFormatter.string(from: NSNumber(value: formattedCurrentTypedNumber))!
    let formattedResultNumberAsString = CookConversionViewModel.model.numberFormatter.string(from: NSNumber(value: result)) ?? "0"
    
    
    previousConversions.append(ConversionItem(search: (measure: currentSelectedPreciseMeasure.name,
                                                       abbreviated: currentSelectedPreciseMeasure.abbreviated ?? currentSelectedPreciseMeasure.name,
                                                       value: formattedCurrentTypedNumberAsString),
                                              response: (measure: currentSelectedCommonMeasure.name,
                                                         abbreviated: currentSelectedCommonMeasure.abbreviated ?? currentSelectedCommonMeasure.name,
                                                         value: formattedResultNumberAsString) ))
    
    Accessibility.postConversionCompletedNotification(conversionInputValue: formattedCurrentTypedNumberAsString,
                                                      inputMeasure: currentSelectedPreciseMeasure.name,
                                                      outputValue: formattedResultNumberAsString,
                                                      outputMeasure: currentSelectedCommonMeasure.name)
  }
  
  
  // MARK: - Auxiliary Functions

  static func getMeasuresFor(_ measurementType: CookConversionModel.MeasurementType) -> [CookConversionModel.Measure] {
    switch measurementType {
    case .preciseMeasure:
      return getPreciseMeasures()
    case .commonMeasure:
      return getCommonMeasures()
    }
  }

  func getOnlyFirstEnabledMeasure(for measurementType: CookConversionModel.MeasurementType) -> CookConversionModel.Measure {
    return getEnabledMeasures(for: measurementType).first!
  }

  func getEnabledMeasures(for measureType: CookConversionModel.MeasurementType) -> [CookConversionModel.Measure] {
      var activeMeasures = [CookConversionModel.Measure]()
      let currentMeasures = CookConversionViewModel.getMeasuresFor(measureType)

      // Gets only the measures that weren't disabled by the user.
      for (measure, isEnabled) in measuresEnabledStatus {
        for currentMeasure in currentMeasures {
          if currentMeasure == measure && isEnabled == true {
            activeMeasures.append(currentMeasure)
          }
        }
      }

      return activeMeasures
  }

  func numberOfEnableItems(for measureType: CookConversionModel.MeasurementType) -> Int {
    return getEnabledMeasures(for: measureType).count
  }

  func increaseCurrentTypedNumberByOne() {
    if currentTypedNumber.isEmpty { currentTypedNumber = "0" }
    guard currentTypedNumberIsValid().booleanResponse != false else {
      handleInvalidCurrentTypedValue()
      return
    }

    var currentTypedNumberAsDouble = CookConversionViewModel.model.numberFormatter.number(from: currentTypedNumber)!.doubleValue
    currentTypedNumberAsDouble += 1
    let newCurrentTypedNumberAsString = CookConversionViewModel.model.numberFormatter.string(from: NSNumber(value: currentTypedNumberAsDouble))!
    currentTypedNumber = newCurrentTypedNumberAsString
  }

  func decreaseCurrentTypedNumberByOne() {
    if currentTypedNumber.isEmpty { currentTypedNumber = "0" }
    if currentTypedNumber == "0" { return }
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
    isShowingCommonMeasureMenu = false
  }
  
  func getCurrentSelectedMeasureFor(_ measurementType: CookConversionModel.MeasurementType) -> CookConversionModel.Measure {
    switch measurementType {
    case .preciseMeasure:
      return currentSelectedPreciseMeasure
    case .commonMeasure:
      return currentSelectedCommonMeasure
    }
  }

  func updateCurrentSelectedMeasures() {
    currentSelectedCommonMeasure = getOnlyFirstEnabledMeasure(for: .commonMeasure)
    currentSelectedPreciseMeasure = getOnlyFirstEnabledMeasure(for: .preciseMeasure)
  }

  private func handleInvalidCurrentTypedValue() {
    buttonIsCurrentlyShowingErrorMessage = true

    // Change the button text to a message saying why the number is invalid
    convertButtonText = currentTypedNumberIsValid().description
    // After 1 sec, start to show the standard button text again (e.g. "Convert")
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.buttonIsCurrentlyShowingErrorMessage = false
      self.convertButtonText = LocalizedStringKey("convert").stringValue()
    }
  }
  
  private func currentTypedNumberIsValid() -> (booleanResponse: Bool, description: String) {
    guard let typedNumberAsDouble = CookConversionViewModel.model.numberFormatter.number(from: currentTypedNumber)?.doubleValue else {
      return (booleanResponse: false, description: LocalizedStringKey("invalid-number").stringValue())
    }
    guard typedNumberAsDouble <= 5000 else {
      return (booleanResponse: false, description: LocalizedStringKey("too-high-number").stringValue())
    }
    // This text will never be showed
    return (booleanResponse: true, description: "Success")
  }
  
}
