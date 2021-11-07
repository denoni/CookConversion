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
  @Published var currentTypedValue: String = ""
  @Published var currentSelectedPreciseMeasure: CookConversionModel.Measure = .preciseMeasure(preciseMeasure: .milliliter)
  @Published var currentSelectedCommonMeasure: CookConversionModel.Measure = .commonMeasure(commonMeasure: .tablespoon)
  @Environment(\.locale) var locale

  @Published var currentLanguage: CookConversionModel.AvailableLanguages {
    didSet {
      UserDefaults.standard.set(currentLanguage.localizedLanguageCode, forKey: "language")
      forceUpdateViewsWithNewLanguage()
    }
  }

  // User can disable a measure so it won't appear in the list anymore. This dictionary controls what is active and what is not.
  @Published var measuresEnabledStatus = [CookConversionModel.Measure: Bool]() {
    didSet {
      if let encodedMeasuresEnabledStatus = try? JSONEncoder().encode(measuresEnabledStatus) {
        UserDefaults.standard.set(encodedMeasuresEnabledStatus, forKey: "measures-enabled-status")
      }
    }
  }

  static var sampleConversionItem: ConversionItem {
    ConversionItem(search: (measure: LocalizedStringKey("ounces").stringValue(),
                            abbreviated:  LocalizedStringKey("ounces-abbreviated").stringValue(),
                            value: "10"),
                   response: (measure: LocalizedStringKey("tablespoons").stringValue(),
                              abbreviated: LocalizedStringKey("tablespoons-abbreviated").stringValue(),
                              value: "20"))
  }

  // Create the list of conversions and add a sample conversion as the first element
  @Published var previousConversions: [ConversionItem]

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

  @objc func localeChanged() { currentLanguage = CookConversionModel.AvailableLanguages.getLanguage(from: Locale.current.languageCode ?? "") }

  init() {
    let encodedMeasuresEnabledStatus = UserDefaults.standard.object(forKey: "measures-enabled-status") as? Data
    let userLanguage = UserDefaults.standard.string(forKey: "language")

    previousConversions = [CookConversionViewModel.sampleConversionItem]

    if userLanguage != nil {
      currentLanguage = CookConversionModel.AvailableLanguages.getLanguage(from: userLanguage!)
    } else {
      currentLanguage = CookConversionModel.AvailableLanguages.getLanguage(from: Locale.current.languageCode!)
    }

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

    NotificationCenter.default.addObserver(self, selector: #selector(localeChanged), name: NSLocale.currentLocaleDidChangeNotification, object: nil)
  }

  // MARK: - Intent(s)
  static func getPreciseMeasures() -> [CookConversionModel.Measure] {
    return model.getPreciseMeasures()
  }
  
  static func getCommonMeasures() -> [CookConversionModel.Measure] {
    return model.getCommonMeasures()
  }
  
  func convert() {

    guard currentTypedValueIsValid().booleanResponse != false else {
      handleInvalidCurrentTypedValue()
      Accessibility.postConversionFailedNotification(errorMessage: convertButtonText)
      return
    }
    stopShowingKeyboardAndMenus()
    
    let formattedCurrentTypedValue = CookConversionViewModel.model.numberFormatter.number(from: currentTypedValue)!.doubleValue
    
    let result = CookConversionViewModel.model.convert(formattedCurrentTypedValue,
                                                       from: currentSelectedPreciseMeasure,
                                                       to: currentSelectedCommonMeasure)
    
    let formattedCurrentTypedValueAsString = CookConversionViewModel.model.numberFormatter.string(from: NSNumber(value: formattedCurrentTypedValue))!
    let formattedResultValueAsString = CookConversionViewModel.model.numberFormatter.string(from: NSNumber(value: result)) ?? "0"
    
    
    previousConversions.append(ConversionItem(search: (measure: currentSelectedPreciseMeasure.name,
                                                       abbreviated: currentSelectedPreciseMeasure.abbreviated ?? currentSelectedPreciseMeasure.name,
                                                       value: formattedCurrentTypedValueAsString),
                                              response: (measure: currentSelectedCommonMeasure.name,
                                                         abbreviated: currentSelectedCommonMeasure.abbreviated ?? currentSelectedCommonMeasure.name,
                                                         value: formattedResultValueAsString) ))
    
    Accessibility.postConversionCompletedNotification(conversionInputValue: formattedCurrentTypedValueAsString,
                                                      inputMeasure: currentSelectedPreciseMeasure.name,
                                                      outputValue: formattedResultValueAsString,
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

  func increaseCurrentTypedValueByOne() {
    if currentTypedValue.isEmpty { currentTypedValue = "0" }
    guard currentTypedValueIsValid().booleanResponse != false else {
      handleInvalidCurrentTypedValue()
      return
    }

    var currentTypedValueAsDouble = CookConversionViewModel.model.numberFormatter.number(from: currentTypedValue)!.doubleValue
    currentTypedValueAsDouble += 1
    let newCurrentTypedValueAsString = CookConversionViewModel.model.numberFormatter.string(from: NSNumber(value: currentTypedValueAsDouble))!
    currentTypedValue = newCurrentTypedValueAsString
  }

  func decreaseCurrentTypedValueByOne() {
    if currentTypedValue.isEmpty { currentTypedValue = "0" }
    if currentTypedValue == "0" { return }
    guard currentTypedValueIsValid().booleanResponse != false else {
      handleInvalidCurrentTypedValue()
      return
    }
    var currentTypedValueAsDouble = CookConversionViewModel.model.numberFormatter.number(from: currentTypedValue)!.doubleValue
    currentTypedValueAsDouble -= 1
    let newCurrentTypedValueAsString = CookConversionViewModel.model.numberFormatter.string(from: NSNumber(value: currentTypedValueAsDouble))!
    currentTypedValue = newCurrentTypedValueAsString
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

  private func forceUpdateViewsWithNewLanguage() {
    // Force update the view button message
    convertButtonText = LocalizedStringKey("convert").stringValue()
    // Add a new conversion to the history in the new language to indicate the change
    previousConversions.append(CookConversionViewModel.sampleConversionItem)
  }

  private func handleInvalidCurrentTypedValue() {
    buttonIsCurrentlyShowingErrorMessage = true

    // Change the button text to a message saying why the number is invalid
    convertButtonText = currentTypedValueIsValid().description
    // After 1 sec, start to show the standard button text again (e.g. "Convert")
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      self.buttonIsCurrentlyShowingErrorMessage = false
      self.convertButtonText = LocalizedStringKey("convert").stringValue()
    }
  }
  
  private func currentTypedValueIsValid() -> (booleanResponse: Bool, description: String) {
    guard let typedValueAsDouble = CookConversionViewModel.model.numberFormatter.number(from: currentTypedValue)?.doubleValue else {
      return (booleanResponse: false, description: LocalizedStringKey("invalid-number").stringValue())
    }
    guard typedValueAsDouble <= 5000 else {
      return (booleanResponse: false, description: LocalizedStringKey("too-high-number").stringValue())
    }
    // This text will never be showed
    return (booleanResponse: true, description: "Success")
  }
  
}
