//
//  CookConversionTests.swift
//  CookConversionTests
//
//  Created by Gabriel on 11/1/21.
//

import XCTest
import SwiftUI
@testable import Cook_Conversion

// MARK: - Input Value Tests
class InputValueTests: XCTestCase {

  // System under test
  var sut: CookConversionViewModel!

  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = CookConversionViewModel()
  }

  override func tearDownWithError() throws {
    sut = nil
    try super.tearDownWithError()
  }

  func testInputValueIsNotANumber() {
    // GIVEN - User typed value that is not a number
    sut.currentTypedValue = "abc"

    // WHEN
    sut.convert()

    // THEN - 'convertButtonText' message showed indication of invalid number
    XCTAssertEqual(sut.convertButtonText, LocalizedStringKey("invalid-number").stringValue())
  }

  func testInputValueIsEmpty() {
    // GIVEN - User typed value that is not a number
    sut.currentTypedValue = ""

    // WHEN
    sut.convert()

    // THEN - 'convertButtonText' message showed indication of an empty
    XCTAssertEqual(sut.convertButtonText, LocalizedStringKey("empty-number").stringValue())
  }

  func testInputValueIsNegative() {
    // GIVEN - User typed value below zero
    sut.currentTypedValue = "-1"
    // WHEN
    sut.convert()

    // THEN - 'convertButtonText' message showed indication of invalid number
    XCTAssertEqual(sut.convertButtonText, LocalizedStringKey("invalid-number").stringValue())
  }

  func testInputValueIsTooHigh() {
    // GIVEN - User typed value that is too high
    sut.currentTypedValue = String(Constants.maxInputValue + 1)

    // WHEN
    sut.convert()

    // THEN - 'convertButtonText' message showed indication of too high number
    XCTAssertEqual(sut.convertButtonText, LocalizedStringKey("too-high-number").stringValue())
  }
}

// MARK: - Stepper Increase/Decrease Tests
class StepperTests: XCTestCase {

  // System under test
  var sut: CookConversionViewModel!

  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = CookConversionViewModel()
  }

  override func tearDownWithError() throws {
    sut = nil
    try super.tearDownWithError()
  }

  func testStepperIncrease() {
    // GIVEN
    sut.currentTypedValue = "10"

    // WHEN - User tapped + stepper
    sut.increaseCurrentTypedValueByOne()

    // THEN - 'currentTypedValue' was increased by one
    XCTAssertEqual(sut.currentTypedValue, "11")
  }

  func testStepperDecrease() {
    // GIVEN
    sut.currentTypedValue = "10"

    // WHEN - User tapped + stepper
    sut.decreaseCurrentTypedValueByOne()

    // THEN - 'currentTypedValue' was decreased by one
    XCTAssertEqual(sut.currentTypedValue, "9")
  }

}

// MARK: - Conversion Results Tests
class ConversionResultsTests: XCTestCase {

  // System under test
  var sut: CookConversionModel!

  let accuracy = 0.01

  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = CookConversionModel()
  }

  override func tearDownWithError() throws {
    sut = nil
    try super.tearDownWithError()
  }

  func testConversionLiterToCups() {
    // GIVEN - 10 Liters converted to Cups
    let valueToConvert = 10.0
    let inputType = CookConversionModel.Measure.preciseMeasure(preciseMeasure: .liter)
    let resultType = CookConversionModel.Measure.commonMeasure(commonMeasure: .cups)


    // WHEN
    let result = sut.convert(valueToConvert, from: inputType, to: resultType)

    // THEN
    XCTAssertEqual(result, 42.27, accuracy: accuracy)
  }

  func testConversionCupsToLiters() {
    // GIVEN - 42.27 Cups converted to Liters
    let valueToConvert = 42.27
    let inputType = CookConversionModel.Measure.commonMeasure(commonMeasure: .cups)
    let resultType = CookConversionModel.Measure.preciseMeasure(preciseMeasure: .liter)

    // WHEN
    let result = sut.convert(valueToConvert, from: inputType, to: resultType)

    // THEN
    XCTAssertEqual(result, 10.0, accuracy: accuracy)
  }

  func testConversionOunceToTablespoon() {
    // GIVEN - 1 Ounce converted to Tablespoons
    let valueToConvert = 1.0
    let inputType = CookConversionModel.Measure.preciseMeasure(preciseMeasure: .ounce)
    let resultType = CookConversionModel.Measure.commonMeasure(commonMeasure: .tablespoon)


    // WHEN
    let result = sut.convert(valueToConvert, from: inputType, to: resultType)

    // THEN
    XCTAssertEqual(result, 2.44, accuracy: accuracy)
  }

  func testConversionTablespoonToOunce() {
    // GIVEN - 2.44 Tablespoons converted to Ounces
    let valueToConvert = 2.44
    let inputType = CookConversionModel.Measure.commonMeasure(commonMeasure: .tablespoon)
    let resultType = CookConversionModel.Measure.preciseMeasure(preciseMeasure: .ounce)

    // WHEN
    let result = sut.convert(valueToConvert, from: inputType, to: resultType)

    // THEN
    XCTAssertEqual(result, 1.0, accuracy: accuracy)
  }

}
