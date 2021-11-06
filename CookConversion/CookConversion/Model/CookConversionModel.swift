//
//  CookConversionModel.swift
//  CookConversion
//
//  Created by Gabriel on 11/2/21.
//

import Foundation

struct CookConversionModel {
  enum MeasurementType {
    case preciseMeasure
    case commonMeasure
  }
  
  enum Measure: Hashable & Codable {
    case preciseMeasure(preciseMeasure: PreciseMeasure)
    case commonMeasure(commonMeasure: CommonMeasure)
    
    enum CommonMeasure: CaseIterable & Codable {
      case teaspoon
      case tablespoon
      case cups
      case teacup
    }
    
    enum PreciseMeasure: CaseIterable & Codable {
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
    case chinese = "zh"

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
      case .chinese:
        return "zh-Hans"
      }
    }

    var languageFullName: String {
      switch self {
      case .english:
        return "English"
      case .portuguese:
        return "Português"
      case .spanish:
        return "Español"
      case .french:
        return "Français"
      case .chinese:
        return "中国人"
      }
    }

    static func getLanguage(from languageCode: String) -> AvailableLanguages {
      for availableLanguageCode in AvailableLanguages.allCases {
        if languageCode == availableLanguageCode.localizedLanguageCode {
          return availableLanguageCode
        }
      }
      // if didn't find a match
      return .english
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
      listOfMeasures.append(.preciseMeasure(preciseMeasure: measure))
    }
    return listOfMeasures
  }
  
  func getCommonMeasures() -> [Measure] {
    var listOfMeasures = [Measure]()
    for measure in Measure.CommonMeasure.allCases {
      listOfMeasures.append(.commonMeasure(commonMeasure: measure))
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
