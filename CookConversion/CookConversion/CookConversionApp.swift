//
//  CookConversionApp.swift
//  CookConversion
//
//  Created by Gabriel on 11/1/21.
//

import SwiftUI

@main
struct CookConversionApp: App {
  @StateObject var cookConversionViewModel = CookConversionViewModel()
  
  var body: some Scene {
    WindowGroup {
      NavigationHandlerScreen()
        .environmentObject(cookConversionViewModel)
    }
  }
}
