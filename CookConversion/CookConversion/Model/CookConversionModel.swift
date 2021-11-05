//
//  CookConversionModel.swift
//  CookConversion
//
//  Created by Gabriel on 11/2/21.
//

import Foundation
import SwiftUI // Need SwiftUI because of LocalizedStringKey

struct CookConversionModel {
  enum MeasurementType {
    case preciseMeasure
    case commonMeasure
  }
  
  enum Measure: Hashable {
    case preciseMeasure(_ preciseMeasure: PreciseMeasure)
    case commonMeasure(_ commonMeasure: CommonMeasure)
    
    enum CommonMeasure: CaseIterable {
      case teaspoon
      case tablespoon
      case cups
      case teacup
    }
    
    enum PreciseMeasure: CaseIterable {
      case ounce
      case gallon
      case gram
      case kilogram
      case milliliter
      case liter
    }
  }

  enum AvailableLanguages: String, CaseIterable {
    case english = "en"
    case portuguese = "pt"
    case spanish = "es"
    case french = "fr"

    var localizedLanguageCode: String {
      switch self {
      case .english:
        return "en"
      case .portuguese:
        return "pt-BR"
      case .spanish:
        return "es"
      case .french:
        return "fr"
      }
    }
  }
  
  let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.locale = Locale.current
    formatter.numberStyle = .decimal
    formatter.minimum = 0
    formatter.maximumFractionDigits = 1
    return formatter
  }()
  
  func convert(_ number: Double, from initialMeasure: Measure, to finalMeasure: Measure) -> Double {
    let measureInGrams = convertToGram(number, from: initialMeasure)
    return convertFromGramToCommonMeasure(measureInGrams, to: finalMeasure)
  }
  
  func getPreciseMeasures() -> [Measure] {
    var listOfMeasures = [Measure]()
    for measure in Measure.PreciseMeasure.allCases {
      listOfMeasures.append(.preciseMeasure(measure))
    }
    return listOfMeasures
  }
  
  func getCommonMeasures() -> [Measure] {
    var listOfMeasures = [Measure]()
    for measure in Measure.CommonMeasure.allCases {
      listOfMeasures.append(.commonMeasure(measure))
    }
    return listOfMeasures
  }
  
  private func convertToGram(_ number: Double, from initialMeasure: Measure) -> Double {
    switch initialMeasure {
    case .preciseMeasure(.ounce):
      return number * 29.5735 / 0.82
    case .preciseMeasure(.gallon):
      return number * 3785.4 / 0.82
    case .preciseMeasure(.gram):
      return number
    case .preciseMeasure(.kilogram):
      return number * 1000
    case .preciseMeasure(.milliliter):
      return number / 0.82 // TODO: Depends on density
    case .preciseMeasure(.liter):
      return number / 0.82 * 1000 // TODO: Depends on density
    default:
      fatalError("Type not implemented for \(initialMeasure)")
    }
  }
  
  private func convertFromGramToCommonMeasure(_ measureInGrams: Double, to finalMeasure: Measure) -> Double {
    switch finalMeasure {
    case .commonMeasure(.teaspoon):
      return measureInGrams / 4.92892 * 0.82
    case .commonMeasure(.tablespoon):
      return measureInGrams / 14.7868 * 0.82
    case .commonMeasure(.cups):
      return measureInGrams / 236.588 * 0.82
    case .commonMeasure(.teacup):
      return measureInGrams / 118.294 * 0.82
    default:
      fatalError("Type not implemented for \(finalMeasure)")
    }
  }
  
}


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

extension CookConversionModel.Measure {
  
  var name: String {
    return self.getNameAndAbbreviation().name
  }
  
  var abbreviated: String? {
    return self.getNameAndAbbreviation().abbreviated
  }
  
  func getNameAndAbbreviation() -> (name: String, abbreviated: String?) {
    switch self {
    case .preciseMeasure(let preciseMeasure):
      return (preciseMeasure.name, preciseMeasure.abbreviated)
    case .commonMeasure(let commonMeasure):
      return (commonMeasure.name, commonMeasure.abbreviated)
    }
  }
}
