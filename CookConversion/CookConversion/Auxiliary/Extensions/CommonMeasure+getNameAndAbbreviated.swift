//
//  CommonMeasure+getNameAndAbbreviated.swift
//  CookConversion
//
//  Created by Gabriel on 11/5/21.
//

import SwiftUI

extension CookConversionModel.Measure.CommonMeasure {

  var name: String {
    return self.getNameAndAbbreviation().name.stringValue()
  }

  var abbreviated: String? {
    return self.getNameAndAbbreviation().abbreviated?.stringValue()
  }

  private func getNameAndAbbreviation() -> (name: LocalizedStringKey, abbreviated: LocalizedStringKey?) {
    switch self {
    case .teaspoon:
      return (name: "teaspoons", abbreviated: "teaspoons-abbreviated")
    case .tablespoon:
      return (name: "tablespoons", abbreviated: "tablespoons-abbreviated")
    case .cups:
      return (name: "cups", abbreviated: nil)
    case .teacup:
      return (name: "teacups", abbreviated: nil)
    }
  }
}
