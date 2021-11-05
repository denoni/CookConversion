//
//  SettingsView.swift
//  CookConversion
//
//  Created by Gabriel on 11/5/21.
//

import SwiftUI

struct SettingsView: View {
  @EnvironmentObject var cookConversionViewModel: CookConversionViewModel
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("PRECISE MEASURES TO SHOW")) {
          ForEach(CookConversionViewModel.getPreciseMeasures(), id: \.self.name) { preciseMeasure in
            Toggle(isOn: Binding($cookConversionViewModel.measuresEnabledStatus[preciseMeasure])!) {
              Text(preciseMeasure.name)
            }
            // Disables the very last enabled item to prevent user from disabling all measures for measure type
            .disabled(cookConversionViewModel.numberOfEnableItems(for: .preciseMeasure) == 1
                      && cookConversionViewModel.measuresEnabledStatus[preciseMeasure]! == true)
          }
        }
        Section(header: Text("COMMON MEASURES TO SHOW")) {
          ForEach(CookConversionViewModel.getCommonMeasures(), id: \.self.name) { commonMeasure in
            Toggle(isOn: Binding($cookConversionViewModel.measuresEnabledStatus[commonMeasure])!) {
              Text(commonMeasure.name)
            }
            // Disables the very last enabled item to prevent user from disabling all measures for measure type
            .disabled(cookConversionViewModel.numberOfEnableItems(for: .commonMeasure) == 1
                      && cookConversionViewModel.measuresEnabledStatus[commonMeasure]! == true)
          }
        }
        // TODO: Add option to select language
      }
      .navigationBarTitle("Settings")
      .navigationBarItems(leading: Button(action: { presentationMode.wrappedValue.dismiss() },
                                          label: { Text("Close") } ))
    }
  }
}

