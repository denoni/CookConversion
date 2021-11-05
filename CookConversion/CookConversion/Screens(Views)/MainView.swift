//
//  MainView.swift
//  CookConversion
//
//  Created by Gabriel on 11/1/21.
//

import SwiftUI

struct MainView: View {
  var body: some View {
    ZStack {
      Color.lightGray
      VStack(spacing: 0) {
        TopSelectionSection()
        ConversionResponses()
        UserInputSection()
      }
    }
    .ignoresSafeArea()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct TopSelectionSection: View {
  @EnvironmentObject var cookConversionViewModel: CookConversionViewModel
  @ObservedObject private var keyboard = KeyboardResponder()
  @Environment(\.topSafeAreaSize) var topSafeAreaSize
  @State var settingsScreenIsOpen = false
  
  var body: some View {
    ZStack {
      Rectangle()
        .foregroundColor(Color.skyBlue)
        .cornerRadius(Constants.bigRadius, corners: [.bottomLeft, .bottomRight])
      VStack {
        HStack {
          Spacer()
          Button(action: {
            settingsScreenIsOpen = true
          }, label: {
            Image(systemName: "gear")
              .resizable()
              .renderingMode(.template)
              .foregroundColor(Color.blackDarkSensitive)
              .frame(width: 25, height: 25)
          })
        }
        .padding(.horizontal, Constants.standardPadding)
        
        HStack(alignment: .bottom, spacing: Constants.smallPadding) {
          TapDownButton(measurementType: .preciseMeasure, isShowingMenu: $cookConversionViewModel.isShowingPreciseMeasureMenu)
          TapDownButton(measurementType: .easyMeasure, isShowingMenu: $cookConversionViewModel.isShowingEasyMeasureMenu)
        }
        .frame(height: Constants.bigButtonHeight)
        .padding(Constants.standardPadding)
      }
      .frame(maxHeight: .infinity)
      .padding(.top, topSafeAreaSize + Constants.standardPadding)
    }
    .ignoresSafeArea()
    .frame(height: topSafeAreaSize + 150)
    .zIndex(1)
    // Need this negative padding otherwise this view will move up when keyboard opens
    .padding(.bottom, -keyboard.currentHeight)
    .onTapGesture { cookConversionViewModel.stopShowingKeyboardAndMenus() }
    .sheet(isPresented: $settingsScreenIsOpen, onDismiss: { cookConversionViewModel.updateCurrentSelectedMeasures() }) {
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
            ForEach(CookConversionViewModel.getEasyMeasures(), id: \.self.name) { easyMeasure in
              Toggle(isOn: Binding($cookConversionViewModel.measuresEnabledStatus[easyMeasure])!) {
                Text(easyMeasure.name)
              }
              // Disables the very last enabled item to prevent user from disabling all measures for measure type
              .disabled(cookConversionViewModel.numberOfEnableItems(for: .easyMeasure) == 1
                        && cookConversionViewModel.measuresEnabledStatus[easyMeasure]! == true)
            }
          }
          // TODO: Add option to select language
        }
        .navigationBarTitle("Settings")
        .navigationBarItems(leading: Button(action: { settingsScreenIsOpen = false },
                                            label: { Text("Close") } ))
      }
    }
  }
}

struct ConversionResponses: View {
  @EnvironmentObject var cookConversionViewModel: CookConversionViewModel
  @ObservedObject private var keyboard = KeyboardResponder()
  @State var currentScrollViewPosition: CGFloat = 0
  func getRandomID() -> String { UUID().uuidString }
  
  var body: some View {
    ZStack {
      
      ReadableScrollView(currentPosition: $currentScrollViewPosition) {
        VStack(spacing: Constants.smallPadding) {
          ForEach(cookConversionViewModel.previousConversions, id: \.self.id) { conversion in
            HStack {
              TextBalloon(horizontalAlignment: .leading,
                          topLabel: conversion.search.label,
                          text: conversion.search.text)
              TextBalloon(horizontalAlignment: .trailing,
                          topLabel: conversion.response.label,
                          text: conversion.response.text)
            }
            .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.6)))
          }
        }
        // The scroll view is reversed, the views need to be reversed again so they don't get upside down
        .rotationEffect(Angle(degrees: 180))
        .padding(.vertical, Constants.standardPadding)
      }
      .padding(.horizontal, 10)
      // To reverse the scroll view
      .rotationEffect(Angle(degrees: 180))
      .onChange(of: currentScrollViewPosition, perform: { _ in
        cookConversionViewModel.stopShowingKeyboardAndMenus()
      })
      
      // Small linear gradient in the top and bottom of the scroll view for a better looking when user scrolls.
      VStack {
        LinearGradient(colors: [.lightGray, .lightGray.opacity(0)], startPoint: .top, endPoint: .bottom)
          .frame(height: 15)
        Spacer()
        LinearGradient(colors: [.lightGray, .lightGray.opacity(0)], startPoint: .bottom, endPoint: .top)
          .frame(height: 15)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.top, -Constants.smallPadding)
    .padding(.vertical, Constants.standardPadding)
    .onTapGesture { cookConversionViewModel.stopShowingKeyboardAndMenus() }
  }
}

struct UserInputSection: View {
  @EnvironmentObject var cookConversionViewModel: CookConversionViewModel
  @ObservedObject private var keyboard = KeyboardResponder()
  @Environment(\.colorScheme) var colorScheme
  
  var body: some View {
    ZStack {
      Rectangle()
        .foregroundColor(Color.whiteDarkSensitive)
        .cornerRadius(Constants.bigRadius, corners: [.topLeft, .topRight])
      VStack {
        HStack {
          
          HStack(spacing: 5) {
            Button(action: { cookConversionViewModel.decreaseCurrentTypedNumberByOne() }, label: {
              RoundedRectangle(cornerRadius: 10, style: .continuous)
                .frame(width: 40, height: 40)
                .foregroundColor(Color.lightGray)
                .overlay(Text("-").font(.title3).bold().foregroundColor(Color.blackDarkSensitive))
            })
            Button(action: { cookConversionViewModel.increaseCurrentTypedNumberByOne() }, label: {
              RoundedRectangle(cornerRadius: 10, style: .continuous)
                .frame(width: 40, height: 40)
                .foregroundColor(Color.lightGray)
                .overlay(Text("+").font(.title3).bold().foregroundColor(Color.blackDarkSensitive))
            })
          }
          .padding(.trailing, Constants.smallPadding)
          
          ZStack {
            RoundedRectangle(cornerRadius: Constants.standardRadius)
              .foregroundColor(Color.lightGray)
            ConversionTextField(textInput: $cookConversionViewModel.currentTypedNumber,
                                placeholderText: "25")
          }
          .scaledToFit()
          
          Text(cookConversionViewModel.currentSelectedPreciseMeasure.getNameAndAbbreviation().name)
            .font(.title2.weight(.heavy))
            .foregroundColor(.blackDarkSensitive)
            .padding(.leading, 5)
        }
        .frame(height: Constants.bigButtonHeight)
        .padding(.bottom, Constants.smallPadding)
        Button(action: { cookConversionViewModel.convert() }, label: {
          ZStack {
            RoundedRectangle(cornerRadius: Constants.standardRadius)
              .foregroundColor(cookConversionViewModel.buttonIsCurrentlyShowingErrorMessage ? .red : .skyBlue)
            Text(cookConversionViewModel.convertButtonText)
              .foregroundColor(colorScheme == .light ? .whiteDarkSensitive : .blackDarkSensitive)
              .font(.title3.weight(.semibold))
          }
        })
          .frame(height: Constants.bigButtonHeight)
          .padding(.bottom, Constants.standardPadding)
        
        Spacer()
      }
      .padding(Constants.standardPadding)
    }
    .frame(height: 150)
    .frame(maxWidth: .infinity)
    .ignoresSafeArea()
    // So when the keyboard opens the view goes up accordingly
    .padding(.bottom, keyboard.currentHeight)
    .animation(.easeOut(duration: 0.16))
    .onTapGesture { cookConversionViewModel.stopShowingKeyboardAndMenus() }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
