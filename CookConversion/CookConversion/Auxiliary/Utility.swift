//
//  Utility.swift
//  CookConversion
//
//  Created by Gabriel on 11/5/21.
//

import Foundation

struct Utility {
  static func getFormattedLanguageCode(for languageCode: String) -> String {
    for language in CookConversionModel.AvailableLanguages.allCases {
      if languageCode == language.rawValue {
        return language.localizedLanguageCode
      }
    }
    print("\(languageCode) is not in CookConversionModel.AvailableLanguages")
    // If this language is not available, return english.
    return "en"
  }
}
