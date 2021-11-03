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
    case easyMeasure
  }

  enum Measure {
    case preciseMeasure(_ preciseMeasure: PreciseMeasure)
    case easyMeasure(_ easyMeasure: EasyMeasure)

    enum EasyMeasure: CaseIterable {
      case teaspoon
      case tablespoon
      case cups
      case wineglass
      case teacup
    }

    enum PreciseMeasure: CaseIterable {
      case ounce
      case gallon
      case milligram
      case gram
      case kilogram
      case milliliter
      case liter
    }
  }

  func convert(_ number: Double, from initialMeasure: Measure, to finalMeasure: Measure) -> Double {
    let measureInGrams = convertToGram(number, from: initialMeasure)
    return convertFromGramToEasyMeasure(measureInGrams, to: finalMeasure)
  }

  func getPreciseMeasures() -> [Measure] {
    var listOfMeasures = [Measure]()
    for measure in Measure.PreciseMeasure.allCases {
      listOfMeasures.append(.preciseMeasure(measure))
    }
    return listOfMeasures
  }

  func getEasyMeasures() -> [Measure] {
    var listOfMeasures = [Measure]()
    for measure in Measure.EasyMeasure.allCases {
      listOfMeasures.append(.easyMeasure(measure))
    }
    return listOfMeasures
  }

  private func convertToGram(_ number: Double, from initialMeasure: Measure) -> Double {
    switch initialMeasure {
    case .preciseMeasure(.ounce):
      return number * 29.5735 / 0.82
    case .preciseMeasure(.gallon):
      return number * 3785.4 / 0.82
    case .preciseMeasure(.milligram):
      return number / 1000
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

  private func convertFromGramToEasyMeasure(_ measureInGrams: Double, to finalMeasure: Measure) -> Double {
    switch finalMeasure {
    case .easyMeasure(.teaspoon):
      return measureInGrams / 4.92892 * 0.82
    case .easyMeasure(.tablespoon):
      return measureInGrams / 14.7868 * 0.82
    case .easyMeasure(.cups):
      return measureInGrams / 236.588 * 0.82
    case .easyMeasure(.wineglass):
      return measureInGrams / 59.1471 * 0.82
    case .easyMeasure(.teacup):
      return measureInGrams / 118.294 * 0.82
    default:
      fatalError("Type not implemented for \(finalMeasure)")
    }
  }

}


extension CookConversionModel.Measure.PreciseMeasure {

  var name: String {
    return self.getNameAndAbbreviation().name
  }

  var abbreviated: String? {
    return self.getNameAndAbbreviation().abbreviated
  }

  private func getNameAndAbbreviation() -> (name: String, abbreviated: String?) {
    switch self {
    case .ounce:
      return (name: "Ounces", abbreviated: "oz.")
    case .gallon:
      return (name: "Gallons", abbreviated: "gal.")
    case .milligram:
      return (name: "Milligrams", abbreviated: "mg")
    case .gram:
      return (name: "Grams", abbreviated: "g")
    case .kilogram:
      return (name: "Kilograms", abbreviated: "kg")
    case .milliliter:
      return (name: "Milliliters", abbreviated: "mL")
    case .liter:
      return (name: "Liters", abbreviated: "L")
    }
  }
}

extension CookConversionModel.Measure.EasyMeasure {

  var name: String {
    return self.getNameAndAbbreviation().name
  }

  var abbreviated: String? {
    return self.getNameAndAbbreviation().abbreviated
  }

  private func getNameAndAbbreviation() -> (name: String, abbreviated: String?) {
    switch self {
    case .teaspoon:
      return (name: "Teaspoons", abbreviated: "tsp.")
    case .tablespoon:
      return (name: "Tablespoons", abbreviated: "tbsp.")
    case .cups:
      return (name: "Cups", abbreviated: nil)
    case .wineglass:
      return (name: "Wineglasses", abbreviated: nil)
    case .teacup:
      return (name: "Teacups", abbreviated: nil)
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
    case .easyMeasure(let easyMeasure):
      return (easyMeasure.name, easyMeasure.abbreviated)
    }
  }
}
