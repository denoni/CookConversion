//
//  Accessibility.swift
//  CookConversion
//
//  Created by Gabriel on 11/5/21.
//

import SwiftUI

struct Accessibility {

  static func postConversionFailedNotification(errorMessage: String) {
    UIAccessibility.post(notification: .screenChanged, argument: "Conversion failed: \(errorMessage)")
  }

  static func postConversionCompletedNotification(conversionInputValue: String,
                                                  inputMeasure: String,
                                                  outputValue: String,
                                                  outputMeasure: String) {
    var formattedConversionInputValue = conversionInputValue
    var formattedOutputValue = outputValue

    // We need to check for commas, because they are not correctly read by the voice over in some language-location combinations.
    if conversionInputValue.contains(",") {
      formattedConversionInputValue = conversionInputValue.replacingOccurrences(of: ",", with: ".")
    }
    if outputValue.contains(",") {
      formattedOutputValue = conversionInputValue.replacingOccurrences(of: ",", with: ".")
    }

    let accessibilityResultNotificationMessage = "Conversion done: \(formattedConversionInputValue + inputMeasure) is equal to \(formattedOutputValue + outputMeasure)"

    UIAccessibility.post(notification: .screenChanged, argument: accessibilityResultNotificationMessage)
  }

}
