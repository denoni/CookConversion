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

  private let preciseMeasures:[(name: String, abbreviated: String)] = [("Ounces", "oz."),
                                                               ("Gallons", "gal."),
                                                               ("Milligrams", "mg"),
                                                               ("Grams", "g"),
                                                               ("Kilograms", "kg"),
                                                               ("Milliliters", "mL"),
                                                               ("Liters", "L")]

  private let easyMeasures: [(name: String, abbreviated: String?)] = [("Teaspoons", "tsp."),
                                                              ("Tablespoons", "tbsp."),
                                                              ("Cups", nil),
                                                              ("Wineglasses", nil),
                                                              ("Teacups", nil)]


  func getPreciseMeasures() -> [(name: String, abbreviated: String)] {
    return preciseMeasures
  }

  func getEasyMeasures() -> [(name: String, abbreviated: String?)] {
    return easyMeasures
  }

}
