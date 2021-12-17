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
        Section(header: Text( LocalizedStringKey("enabled-precise-measures").stringValue() )) {
          ForEach(CookConversionViewModel.getPreciseMeasures(), id: \.self.name) { preciseMeasure in
            Toggle(isOn: Binding($cookConversionViewModel.measuresEnabledStatus[preciseMeasure])!) {
              Text(preciseMeasure.name)
            }
            // Disables the very last enabled item to prevent user from disabling all measures for measure type
            .disabled(cookConversionViewModel.numberOfEnabledItems(for: .preciseMeasure) == 1
                      && cookConversionViewModel.measuresEnabledStatus[preciseMeasure]! == true)
          }
        }
        Section(header: Text( LocalizedStringKey("enabled-common-measures").stringValue() )) {
          ForEach(CookConversionViewModel.getCommonMeasures(), id: \.self.name) { commonMeasure in
            Toggle(isOn: Binding($cookConversionViewModel.measuresEnabledStatus[commonMeasure])!) {
              Text(commonMeasure.name)
            }
            // Disables the very last enabled item to prevent user from disabling all measures for measure type
            .disabled(cookConversionViewModel.numberOfEnabledItems(for: .commonMeasure) == 1
                      && cookConversionViewModel.measuresEnabledStatus[commonMeasure]! == true)
          }
        }
        Section(header: Text( LocalizedStringKey("language-settings").stringValue() )) {
          Section {
            Picker( LocalizedStringKey("language").stringValue() , selection: $cookConversionViewModel.currentLanguage) {
              ForEach(CookConversionModel.AvailableLanguages.allCases, id: \.self) {
                Text($0.languageFullName)
              }
            }
            .accessibilityIdentifier("languageButton")
          }
        }
        Section(header: Text( LocalizedStringKey("precision-info").stringValue() )) {
          
          Section {
            NavigationLink(destination: PrecisionInfoScreen()) {
              Text(LocalizedStringKey("know-more-about-precision").stringValue())
            }
          }
        }
      }
      .navigationBarTitle( LocalizedStringKey("settings").stringValue() )
      .navigationBarItems(leading: Button(action: { presentationMode.wrappedValue.dismiss() },
                                          label: { Text( LocalizedStringKey("close").stringValue() ) } ))
    }
  }

  private struct PrecisionInfoScreen: View {
    var body: some View {
      VStack(alignment: .leading) {
        Text(LocalizedStringKey("precision-title").stringValue())
          .font(.title)
          .bold()
          .padding(.bottom, 5)
        Text(LocalizedStringKey("precision-text").stringValue())
        Spacer()
      }
      .padding(.horizontal, 30)
    }
  }
}

