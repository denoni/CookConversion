//
//  PreciseMeasure+getNameAndAbbreviated.swift
//  CookConversion
//
//  Created by Gabriel on 11/5/21.
//

import SwiftUI

extension CookConversionModel.Measure.PreciseMeasure {

  var name: String {
    return self.getNameAndAbbreviation().name.stringValue()
  }

  var abbreviated: String? {
    return self.getNameAndAbbreviation().abbreviated?.stringValue()
  }

  private func getNameAndAbbreviation() -> (name: LocalizedStringKey, abbreviated: LocalizedStringKey?) {
    switch self {
    case .ounce:
      return (name: "ounces", abbreviated: "ounces-abbreviated")
    case .gallon:
      return (name: "gallons", abbreviated: "gallons-abbreviated")
    case .gram:
      return (name: "grams", abbreviated: "grams-abbreviated")
    case .kilogram:
      return (name: "kilograms", abbreviated: "kilograms-abbreviated")
    case .milliliter:
      return (name: "milliliters", abbreviated: "milliliters-abbreviated")
    case .liter:
      return (name: "liters", abbreviated: "liters-abbreviated")
    }
  }
}
