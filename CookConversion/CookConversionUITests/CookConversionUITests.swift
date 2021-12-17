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

  


}
