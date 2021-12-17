//
//  CookConversionUITests.swift
//  CookConversionUITests
//
//  Created by Gabriel on 11/1/21.
//

import XCTest

class CookConversionUITests: XCTestCase {

  var app: XCUIApplication!

  override func setUpWithError() throws {
    try super.setUpWithError()
    continueAfterFailure = false
    app = XCUIApplication()
    app.launch()
  }

  func testStepperButtons() {
    let app = XCUIApplication()

    // Open text field
    let textField = app.searchFields.element

    // Tap increase button 10 times
    let increaseButton = app.buttons["Increase"]
    for _ in 1...10 {
      increaseButton.tap()
    }

    // Tap decrease button 1 time
    let decreaseButton = app.buttons["Decrease"]
    decreaseButton.tap()

    // Check if textField label contains the result value
    // (can't check if it's equal because there's accessibility description text in the label)
    let textFieldContainsExpectedResult = textField.label.contains("9")

    XCTAssertEqual(textFieldContainsExpectedResult, true, "Expected this label(\(textField.label)) to contain 9")
  }

  func testTextField() {
    let app = XCUIApplication()

    // Open text field
    let textField = app.searchFields.element
    textField.tap()

    // Type 200
    app.keyboards.keys["2"].tap()
    app.keyboards.keys["0"].tap()
    app.keyboards.keys["0"].tap()

    // Check if textField label contains the result value
    // (can't check if it's equal because there's accessibility description text in the label)
    let textFieldContainsExpectedResult = textField.label.contains("200")

    XCTAssertEqual(textFieldContainsExpectedResult, true, "Expected this label(\(textField.label)) to contain 200")
  }

  func testLanguageChange() {

    let app = XCUIApplication()
    app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .scrollView).element.tap()

    app.buttons["settingsButton"].tap()

    let settingsTable = app.tables
    settingsTable.element.firstMatch.swipeUp()
    settingsTable.buttons["languageButton"].tap()

    var currentLanguage = ""

    // Checks if English is not currently selected
    if (settingsTable.switches["English"].value as! String) != "1" {
      settingsTable.switches["English"].tap()
      currentLanguage = "English"
    } else {
      // If English is currently selected, select Português
      settingsTable.switches["Português"].tap()
      currentLanguage = "Português"
    }

    if currentLanguage == "English" {
      let settingsNavigationBar = XCUIApplication().navigationBars["Settings"]
      let settingsTitle = settingsNavigationBar.staticTexts["Settings"].label

      XCTAssertEqual(settingsTitle, "Settings")

      // Close settings
      settingsNavigationBar.buttons["Close"].tap()

      // Assert that that there's a new response ballon in the scroll view that contains "Tablespoons"
      XCTAssertTrue(app.scrollViews.otherElements.staticTexts.debugDescription.contains("Tablespoons"))
    } else {
      let settingsNavigationBar = XCUIApplication().navigationBars["Configurações"]
      let settingsTitle = settingsNavigationBar.staticTexts["Configurações"].label

      XCTAssertEqual(settingsTitle, "Configurações")

      // Close settings
      settingsNavigationBar.buttons["Fechar"].tap()

      // Assert that that there's a new response ballon in the scroll view that contains "Colheres de Sopa"
      XCTAssertTrue(app.scrollViews.otherElements.staticTexts.debugDescription.contains("Colheres de Sopa"))
    }

  }

}
