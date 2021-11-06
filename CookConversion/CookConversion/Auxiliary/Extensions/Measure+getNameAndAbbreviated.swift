//
//  Measure+getNameAndAbbreviated.swift
//  CookConversion
//
//  Created by Gabriel on 11/5/21.
//

import SwiftUI

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
