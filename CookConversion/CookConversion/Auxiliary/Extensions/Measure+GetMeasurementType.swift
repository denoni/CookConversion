//
//  Measure+GetMeasurementType.swift
//  CookConversion
//
//  Created by Gabriel on 11/7/21.
//

import Foundation

extension CookConversionModel.Measure {
  func getMeasureType() -> CookConversionModel.MeasurementType {
    switch self {
    case .preciseMeasure(preciseMeasure: _):
      return .preciseMeasure
    case .commonMeasure(commonMeasure: _):
      return .commonMeasure
    }
  }
}
