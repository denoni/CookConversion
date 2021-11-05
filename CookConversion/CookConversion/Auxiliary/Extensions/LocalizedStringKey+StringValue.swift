//
//  LocalizedStringKey+StringValue.swift
//  CookConversion
//
//  Created by Gabriel on 11/5/21.
//

// Credits to @Mahdi BM on stack overflow for the code

import SwiftUI

// Returns the string value of a LocalizedStringKey

fileprivate extension LocalizedStringKey {
  var stringKey: String {
    let description = "\(self)"

    let components = description.components(separatedBy: "key: \"")
      .map { $0.components(separatedBy: "\",") }

    return components[1][0]
  }
}

fileprivate extension String {
  static func localizedString(for key: String,
                              locale: Locale = .current) -> String {

    let formattedLanguageCode = Utility.getFormattedLanguageCode(for: locale.languageCode ?? "")
    let path = Bundle.main.path(forResource: formattedLanguageCode, ofType: "lproj")!
    let bundle = Bundle(path: path)!
    let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")

    return localizedString
  }
}

extension LocalizedStringKey {
  func stringValue(locale: Locale = .current) -> String {
    return .localizedString(for: self.stringKey, locale: locale)
  }
}
